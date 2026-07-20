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
-- código Lua para o realce e uma subpasta para os índices.
local repositorioFicticio = {
  ["basico/licao.md"] = [[
# Título da Lição

Veja [o código](exemplo.lua), [os projetos](../projetos/) e
[um arquivo não publicado](dados.bin).
]],
  ["basico/exemplo.lua"] = 'local resposta = 42 -- comentário\nprint("oi")\n',
  ["projetos/demo/principal.lua"] = "return 1\n",
}

local configuracao = {
  titulo = "Site de Teste",
  urlDoRepositorio = "https://exemplo.com/repo",
  pastas = {
    { nome = "basico", tema = "Fundamentos fictícios" },
    { nome = "projetos", tema = "Projetos fictícios" },
  },
}

local leitura, escrita, saida = adaptadorDeMemoria.novo(repositorioFicticio)
local estatisticas = nucleo.gerarSite(configuracao, leitura, escrita)

--------------------------------------------------------------------------------
-- estatísticas: 3 fontes; páginas = 3 + índices (basico/, projetos/,
-- projetos/demo/) + inicial = 7

assert(estatisticas.fontes == 3, "esperava 3 fontes, obtive " .. estatisticas.fontes)
assert(estatisticas.paginas == 7, "esperava 7 páginas, obtive " .. estatisticas.paginas)

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
-- pureza na prática: gerar duas vezes dá o MESMO resultado (o núcleo
-- não guarda estado entre execuções)

local _, escrita2, saida2 = adaptadorDeMemoria.novo(repositorioFicticio)
nucleo.gerarSite(configuracao, leitura, escrita2)
for caminho, conteudo in pairs(saida) do
  assert(saida2[caminho] == conteudo, "geração não determinística em " .. caminho)
end

print("núcleo verificado em memória: portas e adaptadores funcionando!")
