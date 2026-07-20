-- testar_nucleo.lua

-- Testa o NÚCLEO do gerador com o adaptador de MEMÓRIA: um repositório
-- fictício de tabelas entra, páginas HTML saem — sem find, sem disco.
-- É a arquitetura hexagonal pagando a conta: este teste roda em
-- QUALQUER plataforma (inclusive no job Windows da CI, onde o
-- adaptador de arquivos POSIX não funciona).

local nucleo = require "nucleo"
local adaptadorDeMemoria = require "adaptador_memoria"

-- um repositório fictício, pequeno mas com os casos que importam:
-- markdown com links relativos (válido, de diretório e quebrado),
-- código Lua para o realce, uma subpasta para os índices e um arquivo
-- fora da trilha (extra.lua) para a seção "Outros arquivos".
local repositorioFicticio = {
  ["basico/licao.md"] = [[
# Título da Lição

Veja [o código](exemplo.lua), [os projetos](../projetos/) e
[um arquivo não publicado](dados.bin).
]],
  ["basico/exemplo.lua"] = 'local resposta = 42 -- comentário\nprint("oi")\n',
  ["basico/extra.lua"] = "print('fora da trilha')\n",
  ["projetos/demo/principal.lua"] = "return 1\n",
}

local configuracao = {
  titulo = "Site de Teste",
  urlDoRepositorio = "https://exemplo.com/repo",
  urlDoSite = "https://exemplo.com/site/",
  pastas = {
    -- basico define a trilha (licao ANTES de exemplo — a ordem
    -- alfabética inverteria); projetos não define, e o índice fica
    -- alfabético como antes.
    { nome = "basico", tema = "Fundamentos fictícios", arquivos = {
      { "licao.md", "a lição guia" },
      { "exemplo.lua", "código de exemplo" },
    } },
    { nome = "projetos", tema = "Projetos fictícios" },
  },
}

local leitura, escrita, saida = adaptadorDeMemoria.novo(repositorioFicticio)
local estatisticas = nucleo.gerarSite(configuracao, leitura, escrita)

--------------------------------------------------------------------------------
-- estatísticas: 4 fontes; páginas = 4 + índices (basico/, projetos/,
-- projetos/demo/) + inicial + 404 = 9

assert(estatisticas.fontes == 4, "esperava 4 fontes, obtive " .. estatisticas.fontes)
assert(estatisticas.paginas == 9, "esperava 9 páginas, obtive " .. estatisticas.paginas)

--------------------------------------------------------------------------------
-- página de markdown: título, link reescrito, link de diretório
-- preservado e link quebrado apontando para a fonte no repositório

local licao = assert(saida["basico/licao.md.html"], "página da lição não gerada")
assert(licao:find("<h1>Título da Lição</h1>", 1, true))
assert(licao:find('href="exemplo.lua.html"', 1, true), "link .lua não foi reescrito")
assert(licao:find('href="../projetos/"', 1, true), "link de diretório foi alterado")
assert(licao:find('href="https://exemplo.com/repo/blob/main/basico/dados.bin"', 1, true),
  "link não publicado deveria apontar para a fonte")
assert(licao:find("<title>Título da Lição — Site de Teste</title>", 1, true))

--------------------------------------------------------------------------------
-- página de código: realce aplicado e HTML escapado

local exemplo = assert(saida["basico/exemplo.lua.html"], "página de código não gerada")
assert(exemplo:find('<span class="palavra-chave">local</span>', 1, true))
assert(exemplo:find('<span class="comentario">-- comentário</span>', 1, true))
assert(exemplo:find('<span class="numero">42</span>', 1, true))

--------------------------------------------------------------------------------
-- índices: por pasta, por subpasta, e a página inicial

local indiceBasico = assert(saida["basico/index.html"], "índice de basico/ não gerado")
assert(indiceBasico:find('href="licao.md.html"', 1, true))
assert(indiceBasico:find('href="exemplo.lua.html"', 1, true))

-- o índice segue a ORDEM da trilha (licao antes de exemplo, apesar da
-- ordem alfabética contrária) e mostra tema e descrições:
local posLicao = assert(indiceBasico:find('href="licao.md.html"', 1, true))
local posExemplo = assert(indiceBasico:find('href="exemplo.lua.html"', 1, true))
assert(posLicao < posExemplo, "índice não está na ordem da trilha")
assert(indiceBasico:find("Fundamentos fictícios", 1, true), "tema da pasta ausente do índice")
assert(indiceBasico:find("a lição guia", 1, true), "descrição da trilha ausente do índice")

-- arquivo no disco fora da trilha entra na seção "Outros arquivos":
local posOutros = assert(indiceBasico:find("Outros arquivos", 1, true),
  "seção de arquivos fora da trilha ausente")
local posExtra = assert(indiceBasico:find('href="extra.lua.html"', 1, true))
assert(posOutros < posExtra and posExemplo < posOutros,
  "extra.lua deveria aparecer depois da trilha, na seção de outros")

-- projetos/ não tem arquivos diretos, mas precisa de índice com a subpasta:
local indiceProjetos = assert(saida["projetos/index.html"], "índice de projetos/ não gerado")
assert(indiceProjetos:find('href="demo/index.html"', 1, true))

local indiceDemo = assert(saida["projetos/demo/index.html"], "índice da subpasta não gerado")
assert(indiceDemo:find('href="principal.lua.html"', 1, true))
-- migalhas da subpasta sobem dois níveis até o início:
assert(indiceDemo:find('href="../../index.html">início</a>', 1, true))

local inicial = assert(saida["index.html"], "página inicial não gerada")
assert(inicial:find("<h1>Site de Teste</h1>", 1, true))
assert(inicial:find('href="basico/index.html"', 1, true))
assert(inicial:find("Fundamentos fictícios", 1, true))

--------------------------------------------------------------------------------
-- favicon embutido (data URI, sem arquivo externo) e página 404 com
-- links ABSOLUTOS (o GitHub Pages a serve em qualquer profundidade)

assert(inicial:find('<link rel="icon" href="data:image/svg+xml,', 1, true),
  "favicon embutido ausente do <head>")

local pagina404 = assert(saida["404.html"], "página 404 não gerada")
assert(pagina404:find("Página não encontrada", 1, true))
assert(pagina404:find('href="https://exemplo.com/site/index.html"', 1, true),
  "o 404 deveria voltar ao índice pela URL absoluta do site")

--------------------------------------------------------------------------------
-- pureza na prática: gerar duas vezes dá o MESMO resultado (o núcleo
-- não guarda estado entre execuções)

local _, escrita2, saida2 = adaptadorDeMemoria.novo(repositorioFicticio)
nucleo.gerarSite(configuracao, leitura, escrita2)
for caminho, conteudo in pairs(saida) do
  assert(saida2[caminho] == conteudo, "geração não determinística em " .. caminho)
end

print("núcleo verificado em memória: portas e adaptadores funcionando!")
