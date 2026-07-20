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
local trilha = require "trilha"

local configuracao = {
  titulo = "Aprendendo Lua",
  urlDoRepositorio = "https://github.com/dionipadilha/aprendendo_lua",
  urlDoSite = "https://dionipadilha.github.io/aprendendo_lua/",

  -- As pastas publicadas — ordem, temas e lições — vêm de trilha.lua,
  -- a FONTE ÚNICA DE VERDADE da organização do repositório (a mesma da
  -- tabela do README; verificar_trilha.lua garante a sincronia):
  pastas = trilha,

  -- sanidade específica DESTE repositório:
  minimoDeFontes = 140,
  paginasEsperadas = {
    "documentacao/comece_aqui.md.html",
    "basico/ola_mundo.lua.html",
    "capi/embutir.c.html",
    "projetos/pluralizador/pluralizador-1.0-1.rockspec.html",
    "404.html",
  },
}

local leitura, escrita = adaptadorDeArquivos.novo { raiz = "..", saida = "_saida" }
local estatisticas = nucleo.gerarSite(configuracao, leitura, escrita)

print(("site gerado em _saida/: %d fontes, %d páginas.")
  :format(estatisticas.fontes, estatisticas.paginas))

-- para verificar_saida.lua, que valida o produto desta geração:
return { configuracao = configuracao, estatisticas = estatisticas }
