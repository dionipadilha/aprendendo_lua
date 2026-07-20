-- gerar.lua

-- Gerador do site estático do repositório (ver README.md desta pasta).
-- Executa a partir de site/:  lua5.4 gerar.lua
--
-- O que ele faz:
--   1. varre as pastas de conteúdo do repositório;
--   2. converte cada .md com markdown.lua e publica cada arquivo de
--      código como página com realce (realce.lua para .lua);
--   3. preserva a ESTRUTURA de pastas na saída — assim os links
--      relativos dos .md continuam válidos, bastando reescrever a
--      extensão (.md/.lua -> .html) e gerar um index.html por pasta
--      (URLs de diretório, como ../projetos/, passam a funcionar);
--   4. termina com asserts de sanidade — a geração É o teste.
--
-- A saída vai para site/_saida/ (gitignorada); a publicação é feita
-- pelo workflow .github/workflows/pages.yml, apenas no main.

-- A varredura usa `find` (POSIX). No Windows, o gerador avisa e
-- encerra com sucesso — o site é gerado e publicado pela CI Linux.
if package.config:sub(1, 1) == "\\" then
  print("Aviso: o gerador do site usa `find` (POSIX); no Windows a geração é pulada.")
  print("(a CI Linux gera e publica o site)")
  return
end

local markdown = require "markdown"
local realcar = require "realce"

--------------------------------------------------------------------------------
-- Configuração

local TITULO_DO_SITE = "Aprendendo Lua"
local URL_DO_REPOSITORIO = "https://github.com/dionipadilha/aprendendo_lua"
local RAIZ = ".."          -- o repositório, visto de dentro de site/
local SAIDA = "_saida"     -- pasta de saída (gitignorada)

-- As pastas publicadas, na ordem e com as descrições da tabela do README:
local PASTAS = {
  { nome = "basico", tema = "Primeiros passos, tipos, cadeias de texto, operadores e formatação" },
  { nome = "controle_de_fluxo", tema = "Condicionais, laços, break, switch e goto" },
  { nome = "funcoes", tema = "Funções, clausuras, varargs, múltiplos retornos e memoização" },
  { nome = "tabelas", tema = "Tabelas, vetores, pilhas, listas, iteradores, buracos/# e cópias" },
  { nome = "poo", tema = "Classes, herança, polimorfismo e interfaces" },
  { nome = "metatabelas", tema = "Metatabelas, metamétodos, proxies e tabelas somente leitura" },
  { nome = "gc", tema = "Coleta de lixo e tabelas fracas" },
  { nome = "corrotinas", tema = "Guias e exemplos de corrotinas" },
  { nome = "erros", tema = "error, assert, pcall, xpcall e try/except" },
  { nome = "modulos", tema = "require, dofile, loadfile e empacotamento com LuaRocks" },
  { nome = "io", tema = "Leitura e escrita de arquivos" },
  { nome = "sistema", tema = "Data e hora, relógio, esperas e números aleatórios" },
  { nome = "banco_de_dados", tema = "Integração com SQLite via CLI" },
  { nome = "capi", tema = "API C: embutir Lua em C e módulos C carregáveis via require" },
  { nome = "padroes", tema = "Padrões de projeto, da fábrica ao MVC e à máquina de estados" },
  { nome = "solid", tema = "Princípios SOLID, um arquivo por princípio" },
  { nome = "testes", tema = "Framework de teste unitário e exemplos de testes" },
  { nome = "projetos", tema = "Projetos completos e soluções dos exercícios" },
  { nome = "documentacao", tema = "Guia de estudos, roteiro, paradigmas e convenções" },
}

-- Extensões publicadas como página de código (além dos .md):
local CODIGO = {
  lua = "lua", c = "c", h = "c", rockspec = "lua",
  yml = "yaml", sql = "sql", txt = "texto",
}

--------------------------------------------------------------------------------
-- Utilitários de arquivo

local function lerArquivo(caminho)
  local arquivo = assert(io.open(caminho, "rb"), "não consegui ler " .. caminho)
  local conteudo = arquivo:read("a")
  arquivo:close()
  return conteudo
end

local function escreverArquivo(caminho, conteudo)
  local arquivo = assert(io.open(caminho, "wb"), "não consegui escrever " .. caminho)
  arquivo:write(conteudo)
  arquivo:close()
end

local function listarArquivos(pasta)
  local lista = {}
  local comando = ("find '%s/%s' -type f | sort"):format(RAIZ, pasta)
  local processo = assert(io.popen(comando))
  for caminho in processo:lines() do
    -- caminho relativo à raiz do repositório (sem o prefixo "../"):
    table.insert(lista, (caminho:gsub("^" .. RAIZ .. "/", "")))
  end
  processo:close()
  return lista
end

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
]]

local function pagina(titulo, migalhas, conteudo, prefixoParaRaiz, urlDaFonte)
  local fonte = urlDaFonte
    and ('· <a href="' .. urlDaFonte .. '">fonte no GitHub</a>') or ""
  return ([[<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>%s — %s</title>
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
]]):format(markdown.escaparHtml(titulo), TITULO_DO_SITE, ESTILO,
    prefixoParaRaiz, TITULO_DO_SITE, migalhas, conteudo,
    URL_DO_REPOSITORIO, fonte)
end

--------------------------------------------------------------------------------
-- Nomes, títulos e links

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

-- Reescreve os links relativos dos .md: alvos publicados ganham .html;
-- URLs de diretório e âncoras ficam como estão; http(s) não é tocado.
local function reescreverLinks(html, paginasPublicadas, caminhoDaPagina)
  local pastaDaPagina = caminhoDaPagina:match("^(.*)/[^/]+$") or ""
  return (html:gsub('href="([^"]+)"', function(alvo)
    if alvo:match("^https?://") or alvo:match("^#") or alvo:match("^mailto:") then
      return 'href="' .. alvo .. '"'
    end
    -- resolve o caminho relativo contra a pasta da página:
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
    -- diretórios (com ou sem / final) e âncoras internas passam direto;
    -- o que não foi publicado aponta para a fonte no GitHub:
    if alvo:match("/$") or paginasPublicadas[normalizado .. "/"] then
      return 'href="' .. alvo .. '"'
    end
    return 'href="' .. URL_DO_REPOSITORIO .. "/blob/main/" .. normalizado .. '"'
  end))
end

--------------------------------------------------------------------------------
-- Geração

os.execute(("rm -rf '%s' && mkdir -p '%s'"):format(SAIDA, SAIDA))

-- 1ª passada: inventário do que será publicado (para reescrever links):
local arquivosPorPasta = {}
local paginasPublicadas = {} -- caminho relativo -> true
local totalDeFontes = 0

for _, pasta in ipairs(PASTAS) do
  arquivosPorPasta[pasta.nome] = {}
  for _, caminho in ipairs(listarArquivos(pasta.nome)) do
    local nomeDoArquivo = caminho:match("([^/]+)$")
    local extensao = caminho:match("%.([%w]+)$")
    if nomeDoArquivo ~= "Makefile" then
      extensao = extensao and extensao:lower()
    end
    if extensao == "md" or CODIGO[extensao] or nomeDoArquivo == "Makefile" then
      table.insert(arquivosPorPasta[pasta.nome], caminho)
      paginasPublicadas[caminho] = true
      -- marca os diretórios do caminho (para links ../pasta/ e subpastas):
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
local subpastas = {} -- diretorio -> lista de caminhos publicados nele

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

for _, pasta in ipairs(PASTAS) do
  for _, caminho in ipairs(arquivosPorPasta[pasta.nome]) do
    local conteudo = lerArquivo(RAIZ .. "/" .. caminho)
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

    -- garante a pasta de saída e escreve a página:
    local diretorioDeSaida = SAIDA .. "/" .. (caminho:match("^(.*)/[^/]+$") or "")
    os.execute(("mkdir -p '%s'"):format(diretorioDeSaida))
    local urlDaFonte = URL_DO_REPOSITORIO .. "/blob/main/" .. caminho
    escreverArquivo(SAIDA .. "/" .. caminho .. ".html",
      pagina(titulo, migalhasPara(caminho), corpo, prefixoParaRaiz(caminho), urlDaFonte))
    totalDePaginas = totalDePaginas + 1

    local diretorio = caminho:match("^(.*)/[^/]+$")
    subpastas[diretorio] = subpastas[diretorio] or {}
    table.insert(subpastas[diretorio], caminho)
  end
end

-- 3ª passada: um index.html por diretório com a lista dos arquivos.
-- Percorre TODOS os diretórios do inventário — inclusive os que só
-- contêm subpastas (como projetos/), que também precisam de índice.
local diretorios = {}
for chave in pairs(paginasPublicadas) do
  if chave:match("/$") then
    table.insert(diretorios, (chave:gsub("/$", "")))
  end
end
table.sort(diretorios)

for _, diretorio in ipairs(diretorios) do
  local itens = {}
  for _, caminho in ipairs(subpastas[diretorio] or {}) do
    table.insert(itens, ('<li><a href="%s.html"><code>%s</code></a></li>')
      :format(caminho:match("([^/]+)$"), caminho:match("([^/]+)$")))
  end
  -- links para as subpastas diretas deste diretório (comparação por
  -- prefixo, sem padrões — nomes de pasta não são escapados):
  for _, outro in ipairs(diretorios) do
    local ehFilhoDireto = outro:sub(1, #diretorio + 1) == diretorio .. "/"
      and not outro:sub(#diretorio + 2):find("/", 1, true)
    if ehFilhoDireto then
      table.insert(itens, ('<li><a href="%s/index.html">%s/</a></li>')
        :format(outro:match("([^/]+)$"), outro:match("([^/]+)$")))
    end
  end
  table.sort(itens)
  local caminhoFicticio = diretorio .. "/index"
  local corpo = ("<h1><code>%s/</code></h1>\n<ul class=\"arquivos\">%s</ul>")
    :format(diretorio, table.concat(itens))
  escreverArquivo(SAIDA .. "/" .. diretorio .. "/index.html",
    pagina(diretorio .. "/", migalhasPara(caminhoFicticio), corpo,
      prefixoParaRaiz(caminhoFicticio)))
  totalDePaginas = totalDePaginas + 1
end

-- 4ª passada: a página inicial, com a tabela de pastas e a porta de entrada.
local indice = {
  "<h1>" .. TITULO_DO_SITE .. "</h1>",
  [[<p>Guia completo de Lua 5.4 em pt-BR — todos os exemplos são
executáveis, autoverificados com <code>assert</code> e testados na CI
em Linux e Windows. Este site é gerado do
<a href="]] .. URL_DO_REPOSITORIO .. [[">repositório</a> por um script
Lua.</p>]],
  [[<p><strong>Novo por aqui?</strong> Comece pelo
<a href="documentacao/comece_aqui.md.html">roteiro guiado de 3 dias</a>.</p>]],
  "<table><thead><tr><th>Pasta</th><th>Tema</th></tr></thead><tbody>",
}
for _, pasta in ipairs(PASTAS) do
  table.insert(indice, ('<tr><td><a href="%s/index.html"><code>%s/</code></a></td><td>%s</td></tr>')
    :format(pasta.nome, pasta.nome, pasta.tema))
end
table.insert(indice, "</tbody></table>")
escreverArquivo(SAIDA .. "/index.html",
  pagina("início", "", table.concat(indice, "\n"), ""))
totalDePaginas = totalDePaginas + 1

--------------------------------------------------------------------------------
-- Asserts de sanidade: a geração é o teste.

assert(totalDeFontes > 140, "esperava mais de 140 arquivos-fonte, achei " .. totalDeFontes)
assert(totalDePaginas > totalDeFontes,
  "esperava mais páginas que fontes (índices), obtive " .. totalDePaginas)

-- páginas-chave existem e têm conteúdo:
for _, caminho in ipairs {
  "index.html",
  "documentacao/comece_aqui.md.html",
  "basico/ola_mundo.lua.html",
  "capi/embutir.c.html",
  "projetos/pluralizador/pluralizador-1.0-1.rockspec.html",
} do
  local arquivo = assert(io.open(SAIDA .. "/" .. caminho, "rb"),
    "página esperada não existe: " .. caminho)
  assert(#arquivo:read("a") > 500, "página suspeitamente vazia: " .. caminho)
  arquivo:close()
end

print(("site gerado em %s/: %d fontes, %d páginas.")
  :format(SAIDA, totalDeFontes, totalDePaginas))
