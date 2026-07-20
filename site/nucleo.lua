-- nucleo.lua

-- O NÚCLEO do gerador do site — o domínio da arquitetura hexagonal
-- (ver README.md desta pasta). Aqui vive toda a decisão: o que
-- publicar, títulos, reescrita de links, migalhas, índices e o modelo
-- das páginas. Aqui NÃO vive nenhuma E/S: nada de io.*, os.* ou find.
--
-- O mundo exterior entra pelas duas PORTAS, injetadas em gerarSite:
--   leitura: { listar(pasta) -> lista de caminhos relativos à raiz,
--              ler(caminho) -> conteúdo do arquivo }
--   escrita: { preparar(), escrever(caminho, conteudo) }
-- Quem implementa as portas são os adaptadores (adaptador_arquivos
-- para o disco, adaptador_memoria para os testes).
--
-- markdown.lua e realce.lua são serviços PUROS e não ganham porta:
-- não há segunda implementação plausível deles — abstrair sem variação
-- real seria indireção sem retorno (a lição discute essa escolha).

local markdown = require "markdown"
local realcar = require "realce"

local nucleo = {}

-- Extensões publicadas como página de código (além dos .md):
local CODIGO = {
  lua = "lua", c = "c", h = "c", rockspec = "lua",
  yml = "yaml", sql = "sql", txt = "texto",
}

--------------------------------------------------------------------------------
-- O modelo de página (CSS embutido: sem assets externos)

local ESTILO = [[
:root { --fundo: #ffffff; --tinta: #1a1a1a; --suave: #f4f4f2; --borda: #ddd;
        --realce: #00507a; --comentario: #6a737d; --texto-lua: #a31515;
        --palavra: #0000c0; --numero: #098658; }
@media (prefers-color-scheme: dark) {
  :root { --fundo: #16181d; --tinta: #d8dce2; --suave: #21242b; --borda: #333;
          --realce: #6cb6ff; --comentario: #8b949e; --texto-lua: #e0a86c;
          --palavra: #7ea6e0; --numero: #7cc38f; }
}
* { box-sizing: border-box; }
body { margin: 0 auto; max-width: 56rem; padding: 1rem 1.2rem 4rem;
       background: var(--fundo); color: var(--tinta);
       font: 17px/1.65 system-ui, sans-serif; }
a { color: var(--realce); }
header { border-bottom: 1px solid var(--borda); padding-bottom: .6rem;
         margin-bottom: 1.4rem; }
header a { text-decoration: none; }
header .titulo { font-weight: 700; font-size: 1.05rem; }
nav.migalhas { font-size: .85rem; color: var(--comentario); }
pre { background: var(--suave); border: 1px solid var(--borda);
      border-radius: 8px; padding: .9rem 1rem; overflow-x: auto;
      font-size: .86rem; line-height: 1.55; }
code { font-family: ui-monospace, monospace; }
p code, li code, td code, h1 code, h2 code, h3 code {
  background: var(--suave); border-radius: 4px; padding: .08em .35em;
  font-size: .88em; }
table { border-collapse: collapse; width: 100%; display: block;
        overflow-x: auto; }
th, td { border: 1px solid var(--borda); padding: .45rem .6rem;
         text-align: left; }
blockquote { border-left: 4px solid var(--borda); margin: 1rem 0;
             padding: .1rem 1rem; color: inherit; background: var(--suave); }
footer { margin-top: 3rem; border-top: 1px solid var(--borda);
         padding-top: .8rem; font-size: .85rem; color: var(--comentario); }
.comentario { color: var(--comentario); }
.texto-lua { color: var(--texto-lua); }
.palavra-chave { color: var(--palavra); font-weight: 600; }
.numero { color: var(--numero); }
ul.arquivos { padding-left: 1.2rem; }
ul.arquivos li { margin: .15rem 0; }
p.tema { color: var(--comentario); }
.descricao { color: var(--comentario); }
]]

-- Favicon embutido (nenhum arquivo externo): um SVG em data URI com o
-- emoji de lua. %3C/%3E/%20 codificam <, > e espaço; %F0%9F%8C%99 é o
-- emoji 🌙 em UTF-8 percento-codificado.
local FAVICON = "data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'"
  .. "%20viewBox='0%200%2016%2016'%3E%3Ctext%20x='0'%20y='13'%20"
  .. "font-size='13'%3E%F0%9F%8C%99%3C/text%3E%3C/svg%3E"

--------------------------------------------------------------------------------
-- Nomes, títulos e links (funções puras)

local function profundidade(caminhoRelativo)
  local barras = select(2, caminhoRelativo:gsub("/", ""))
  return barras
end

local function prefixoParaRaiz(caminhoRelativo)
  return ("../"):rep(profundidade(caminhoRelativo))
end

local function tituloDoArquivo(caminhoRelativo, conteudo, extensao)
  if extensao == "md" then
    local titulo = conteudo:match("^#+%s+([^\n]+)")
      or conteudo:match("\n#+%s+([^\n]+)")
    if titulo then return (titulo:gsub("%*", "")) end
  end
  return caminhoRelativo:match("([^/]+)$")
end

function nucleo.gerarSite(configuracao, leitura, escrita)
  local tituloDoSite = configuracao.titulo
  local urlDoRepositorio = configuracao.urlDoRepositorio
  local pastasDoSite = configuracao.pastas

  -- A trilha pedagógica (trilha.lua, via configuracao.pastas): posição
  -- e descrição de cada lição, para ordenar os índices por pasta. O
  -- campo `arquivos` é opcional — sem ele, o índice sai alfabético.
  local infoDaTrilha = {}
  local temaDoDiretorio = {}
  local proximaOrdem = 0
  for _, pasta in ipairs(pastasDoSite) do
    temaDoDiretorio[pasta.nome] = pasta.tema
    for _, item in ipairs(pasta.arquivos or {}) do
      proximaOrdem = proximaOrdem + 1
      infoDaTrilha[pasta.nome .. "/" .. item[1]] =
        { ordem = proximaOrdem, descricao = item[2] }
    end
  end

  local function pagina(titulo, migalhas, conteudo, prefixo, urlDaFonte)
    local fonte = urlDaFonte
      and ('· <a href="' .. urlDaFonte .. '">fonte no GitHub</a>') or ""
    return ([[<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>%s — %s</title>
<link rel="icon" href="%s">
<style>%s</style>
</head>
<body>
<header>
  <div class="titulo"><a href="%sindex.html">%s</a></div>
  <nav class="migalhas">%s</nav>
</header>
<main>
%s
</main>
<footer>Gerado por <a href="%s">site/gerar.lua</a> — um script Lua deste
repositório %s</footer>
</body>
</html>
]]):format(markdown.escaparHtml(titulo), tituloDoSite, FAVICON, ESTILO,
      prefixo, tituloDoSite, migalhas, conteudo,
      urlDoRepositorio, fonte)
  end

  -- Reescreve os links relativos dos .md: alvos publicados ganham
  -- .html; URLs de diretório e âncoras ficam; http(s) não é tocado.
  local function reescreverLinks(html, paginasPublicadas, caminhoDaPagina)
    local pastaDaPagina = caminhoDaPagina:match("^(.*)/[^/]+$") or ""
    return (html:gsub('href="([^"]+)"', function(alvo)
      if alvo:match("^https?://") or alvo:match("^#") or alvo:match("^mailto:") then
        return 'href="' .. alvo .. '"'
      end
      local absoluto = (pastaDaPagina == "" and "" or pastaDaPagina .. "/") .. alvo
      local partes = {}
      for parte in absoluto:gmatch("[^/]+") do
        if parte == ".." then
          table.remove(partes)
        elseif parte ~= "." then
          table.insert(partes, parte)
        end
      end
      local normalizado = table.concat(partes, "/")
      if paginasPublicadas[normalizado] then
        return 'href="' .. alvo .. '.html"'
      end
      if alvo:match("/$") or paginasPublicadas[normalizado .. "/"] then
        return 'href="' .. alvo .. '"'
      end
      return 'href="' .. urlDoRepositorio .. "/blob/main/" .. normalizado .. '"'
    end))
  end

  local function migalhasPara(caminho)
    local prefixo = prefixoParaRaiz(caminho)
    local trilha = { '<a href="' .. prefixo .. 'index.html">início</a>' }
    local acumulado, subidas = "", profundidade(caminho)
    for parte in caminho:gmatch("([^/]+)/") do
      acumulado = acumulado .. parte .. "/"
      subidas = subidas - 1
      table.insert(trilha, ('<a href="%sindex.html">%s</a>')
        :format(("../"):rep(subidas) .. "", parte))
    end
    table.insert(trilha, caminho:match("([^/]+)$"))
    return table.concat(trilha, " / ")
  end

  ------------------------------------------------------------------------------
  -- Geração

  escrita.preparar()

  -- registro do que foi escrito, para os asserts de sanidade:
  local tamanhosEscritos = {}
  local function escrever(caminho, conteudo)
    tamanhosEscritos[caminho] = #conteudo
    escrita.escrever(caminho, conteudo)
  end

  -- 1ª passada: inventário do que será publicado (para reescrever links):
  local arquivosPorPasta = {}
  local paginasPublicadas = {}
  local totalDeFontes = 0

  for _, pasta in ipairs(pastasDoSite) do
    arquivosPorPasta[pasta.nome] = {}
    for _, caminho in ipairs(leitura.listar(pasta.nome)) do
      local nomeDoArquivo = caminho:match("([^/]+)$")
      local extensao = caminho:match("%.([%w]+)$")
      if nomeDoArquivo ~= "Makefile" then
        extensao = extensao and extensao:lower()
      end
      if extensao == "md" or CODIGO[extensao] or nomeDoArquivo == "Makefile" then
        table.insert(arquivosPorPasta[pasta.nome], caminho)
        paginasPublicadas[caminho] = true
        local diretorio = caminho:match("^(.*)/[^/]+$")
        while diretorio do
          paginasPublicadas[diretorio .. "/"] = true
          diretorio = diretorio:match("^(.*)/[^/]+$")
        end
        totalDeFontes = totalDeFontes + 1
      end
    end
  end

  -- 2ª passada: gera as páginas.
  local totalDePaginas = 0
  local subpastas = {}

  for _, pasta in ipairs(pastasDoSite) do
    for _, caminho in ipairs(arquivosPorPasta[pasta.nome]) do
      local conteudo = leitura.ler(caminho)
      local nomeDoArquivo = caminho:match("([^/]+)$")
      local extensao = nomeDoArquivo == "Makefile" and "make"
        or caminho:match("%.([%w]+)$"):lower()

      local corpo
      local titulo = tituloDoArquivo(caminho, conteudo, extensao)
      if extensao == "md" then
        corpo = markdown.converter(conteudo, { realcarLua = realcar })
        corpo = reescreverLinks(corpo, paginasPublicadas, caminho)
      else
        local codigoHtml = (extensao == "lua" or extensao == "rockspec")
          and realcar(conteudo) or markdown.escaparHtml(conteudo)
        corpo = ("<h1><code>%s</code></h1>\n<pre><code class=\"linguagem-%s\">%s</code></pre>")
          :format(markdown.escaparHtml(nomeDoArquivo),
            CODIGO[extensao] or "make", codigoHtml)
      end

      local urlDaFonte = urlDoRepositorio .. "/blob/main/" .. caminho
      escrever(caminho .. ".html",
        pagina(titulo, migalhasPara(caminho), corpo, prefixoParaRaiz(caminho), urlDaFonte))
      totalDePaginas = totalDePaginas + 1

      local diretorio = caminho:match("^(.*)/[^/]+$")
      subpastas[diretorio] = subpastas[diretorio] or {}
      table.insert(subpastas[diretorio], caminho)
    end
  end

  -- 3ª passada: um index.html por diretório com a lista dos arquivos —
  -- na ORDEM da trilha e com as descrições, quando a pasta as define;
  -- arquivos no disco que faltem na trilha entram no fim, numa seção
  -- "Outros arquivos" (o gerador nunca quebra por causa da trilha —
  -- quem cobra o registro é verificar_trilha.lua). Percorre TODOS os
  -- diretórios do inventário — inclusive os que só contêm subpastas
  -- (como projetos/), que também precisam de índice.
  local diretorios = {}
  for chave in pairs(paginasPublicadas) do
    if chave:match("/$") then
      table.insert(diretorios, (chave:gsub("/$", "")))
    end
  end
  table.sort(diretorios)

  local function itemDeArquivo(caminho)
    local nome = caminho:match("([^/]+)$")
    local info = infoDaTrilha[caminho]
    local descricao = (info and info.descricao)
      and (' <span class="descricao">— ' .. markdown.escaparHtml(info.descricao) .. "</span>")
      or ""
    return ('<li><a href="%s.html"><code>%s</code></a>%s</li>')
      :format(nome, nome, descricao)
  end

  -- a posição de um diretório na trilha é a da sua primeira lição:
  local function primeiraOrdemDentroDe(diretorio)
    local primeira = math.huge
    for caminho, info in pairs(infoDaTrilha) do
      if caminho:sub(1, #diretorio + 1) == diretorio .. "/"
        and info.ordem < primeira then
        primeira = info.ordem
      end
    end
    return primeira
  end

  for _, diretorio in ipairs(diretorios) do
    -- arquivos diretos: os da trilha na ordem pedagógica; o resto à parte.
    local daTrilha, fora = {}, {}
    for _, caminho in ipairs(subpastas[diretorio] or {}) do
      table.insert(infoDaTrilha[caminho] and daTrilha or fora, caminho)
    end
    table.sort(daTrilha, function(a, b)
      return infoDaTrilha[a].ordem < infoDaTrilha[b].ordem
    end)
    table.sort(fora)

    -- subpastas diretas, na ordem da primeira lição de cada uma:
    local filhos = {}
    for _, outro in ipairs(diretorios) do
      local ehFilhoDireto = outro:sub(1, #diretorio + 1) == diretorio .. "/"
        and not outro:sub(#diretorio + 2):find("/", 1, true)
      if ehFilhoDireto then
        table.insert(filhos, { nome = outro:match("([^/]+)$"),
          ordem = primeiraOrdemDentroDe(outro) })
      end
    end
    table.sort(filhos, function(a, b)
      if a.ordem ~= b.ordem then return a.ordem < b.ordem end
      return a.nome < b.nome
    end)

    local itens = {}
    for _, caminho in ipairs(daTrilha) do
      table.insert(itens, itemDeArquivo(caminho))
    end
    for _, filho in ipairs(filhos) do
      table.insert(itens, ('<li><a href="%s/index.html">%s/</a></li>')
        :format(filho.nome, filho.nome))
    end

    local secaoOutros = ""
    if #fora > 0 then
      if #itens == 0 then
        -- pasta sem trilha nenhuma: mantém a lista única, alfabética.
        for _, caminho in ipairs(fora) do
          table.insert(itens, itemDeArquivo(caminho))
        end
      else
        local itensFora = {}
        for _, caminho in ipairs(fora) do
          table.insert(itensFora, itemDeArquivo(caminho))
        end
        secaoOutros = "\n<h2>Outros arquivos</h2>\n<ul class=\"arquivos\">"
          .. table.concat(itensFora) .. "</ul>"
      end
    end

    local tema = temaDoDiretorio[diretorio]
    local paragrafoDoTema = tema
      and ('\n<p class="tema">' .. markdown.escaparHtml(tema) .. "</p>") or ""
    local caminhoFicticio = diretorio .. "/index"
    local corpo = ("<h1><code>%s/</code></h1>%s\n<ul class=\"arquivos\">%s</ul>%s")
      :format(diretorio, paragrafoDoTema, table.concat(itens), secaoOutros)
    escrever(diretorio .. "/index.html",
      pagina(diretorio .. "/", migalhasPara(caminhoFicticio), corpo,
        prefixoParaRaiz(caminhoFicticio)))
    totalDePaginas = totalDePaginas + 1
  end

  -- 4ª passada: a página inicial, com a tabela de pastas e a porta de entrada.
  local indice = {
    "<h1>" .. tituloDoSite .. "</h1>",
    [[<p>Guia completo de Lua 5.4 em pt-BR — todos os exemplos são
executáveis, autoverificados com <code>assert</code> e testados na CI
em Linux e Windows. Este site é gerado do
<a href="]] .. urlDoRepositorio .. [[">repositório</a> por um script
Lua.</p>]],
    [[<p><strong>Novo por aqui?</strong> Comece pelo
<a href="documentacao/comece_aqui.md.html">roteiro guiado de 3 dias</a>.</p>]],
    "<table><thead><tr><th>Pasta</th><th>Tema</th></tr></thead><tbody>",
  }
  for _, pasta in ipairs(pastasDoSite) do
    table.insert(indice, ('<tr><td><a href="%s/index.html"><code>%s/</code></a></td><td>%s</td></tr>')
      :format(pasta.nome, pasta.nome, markdown.escaparHtml(pasta.tema)))
  end
  table.insert(indice, "</tbody></table>")
  escrever("index.html",
    pagina("início", "", table.concat(indice, "\n"), ""))
  totalDePaginas = totalDePaginas + 1

  -- 5ª passada: a página 404. O GitHub Pages serve o 404.html da RAIZ
  -- da saída para qualquer URL inexistente do site, em qualquer
  -- profundidade — por isso os links daqui usam a URL absoluta do site
  -- (configuracao.urlDoSite) em vez de caminhos relativos.
  local urlDoSite = configuracao.urlDoSite or ""
  local corpo404 = table.concat({
    "<h1>Página não encontrada</h1>",
    "<p>O endereço que você tentou abrir não existe neste site — talvez",
    "o arquivo tenha sido renomeado ou movido.</p>",
    ('<p><a href="%sindex.html">Voltar ao índice</a></p>'):format(urlDoSite),
  }, "\n")
  escrever("404.html",
    pagina("página não encontrada", "", corpo404, urlDoSite))
  totalDePaginas = totalDePaginas + 1

  ------------------------------------------------------------------------------
  -- Asserts de sanidade: a geração é o teste, com qualquer adaptador.

  local minimoDeFontes = configuracao.minimoDeFontes or 1
  assert(totalDeFontes >= minimoDeFontes,
    ("esperava ao menos %d arquivos-fonte, achei %d"):format(minimoDeFontes, totalDeFontes))
  assert(totalDePaginas > totalDeFontes,
    "esperava mais páginas que fontes (índices), obtive " .. totalDePaginas)

  assert(tamanhosEscritos["index.html"], "a página inicial não foi escrita")
  for _, caminho in ipairs(configuracao.paginasEsperadas or {}) do
    assert(tamanhosEscritos[caminho], "página esperada não existe: " .. caminho)
    assert(tamanhosEscritos[caminho] > 500, "página suspeitamente vazia: " .. caminho)
  end

  return { fontes = totalDeFontes, paginas = totalDePaginas }
end

return nucleo
