-- arquivo_com_close.lua

-- Variáveis to-be-closed (Lua 5.4): local f <close>
--
-- Um arquivo aberto com <close> é fechado automaticamente quando a
-- variável sai de escopo — inclusive se um erro interromper o bloco.
-- É o idioma moderno para garantir a liberação de recursos, sem
-- depender de lembrar do arquivo:close() em todos os caminhos.

local NOME_DO_ARQUIVO = "arquivo_close_demo.txt"

-- #1. Fechamento automático no fim do bloco:
do
  local arquivo <close> = assert(io.open(NOME_DO_ARQUIVO, "w"))
  arquivo:write("primeira linha\n")
  -- sem arquivo:close(): o <close> fecha ao sair do bloco
end

-- O arquivo foi fechado e o conteúdo persistido:
local leitura = assert(io.open(NOME_DO_ARQUIVO, "r"))
local conteudo = leitura:read("a")
assert(leitura:close())
assert(conteudo == "primeira linha\n")
print("Fechado automaticamente; conteúdo:", conteudo) --> primeira linha

-- #2. Fechamento garantido mesmo com erro no meio do bloco:
local ok, erro = pcall(function()
  local arquivo <close> = assert(io.open(NOME_DO_ARQUIVO, "w"))
  arquivo:write("linha antes do erro\n")
  error("falha proposital no meio do processamento")
end)
assert(not ok and erro:find("falha proposital"))

-- Mesmo com o erro, o arquivo foi fechado e o conteúdo gravado:
leitura = assert(io.open(NOME_DO_ARQUIVO, "r"))
conteudo = leitura:read("a")
assert(leitura:close())
assert(conteudo == "linha antes do erro\n")
print("Fechado mesmo com erro; conteúdo:", conteudo) --> linha antes do erro

-- Limpeza do artefato de demonstração:
assert(os.remove(NOME_DO_ARQUIVO))
