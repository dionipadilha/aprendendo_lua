-- gerar.lua

-- A RAIZ DE COMPOSIÇÃO do gerador do site (arquitetura hexagonal —
-- ver README.md). Este arquivo conta a história inteira: monta a
-- configuração, instancia o adaptador de disco e entrega tudo ao
-- núcleo. A lógica mora em nucleo.lua; a E/S, em adaptador_arquivos.
--
-- Executa a partir de site/:  lua5.4 gerar.lua
-- Saída em site/_saida/ (gitignorada); a publicação é feita pelo
-- workflow .github/workflows/pages.yml, apenas no main.

-- O adaptador de disco usa `find` (POSIX); no Windows a geração é
-- pulada — o NÚCLEO, porém, é testado em qualquer plataforma pelo
-- testar_nucleo.lua, via adaptador de memória.
if package.config:sub(1, 1) == "\\" then
  print("Aviso: o adaptador de arquivos usa `find` (POSIX); no Windows a geração é pulada.")
  print("(a CI Linux gera e publica o site; o núcleo é testado por testar_nucleo.lua)")
  return
end

local nucleo = require "nucleo"
local adaptadorDeArquivos = require "adaptador_arquivos"

local configuracao = {
  titulo = "Aprendendo Lua",
  urlDoRepositorio = "https://github.com/dionipadilha/aprendendo_lua",

  -- As pastas publicadas, na ordem e com as descrições da tabela do README:
  pastas = {
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
    { nome = "site", tema = "O gerador deste site em arquitetura hexagonal (autopublicado)" },
  },

  -- sanidade específica DESTE repositório:
  minimoDeFontes = 140,
  paginasEsperadas = {
    "documentacao/comece_aqui.md.html",
    "basico/ola_mundo.lua.html",
    "capi/embutir.c.html",
    "projetos/pluralizador/pluralizador-1.0-1.rockspec.html",
  },
}

local leitura, escrita = adaptadorDeArquivos.novo { raiz = "..", saida = "_saida" }
local estatisticas = nucleo.gerarSite(configuracao, leitura, escrita)

print(("site gerado em _saida/: %d fontes, %d páginas.")
  :format(estatisticas.fontes, estatisticas.paginas))
