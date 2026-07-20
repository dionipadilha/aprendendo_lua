-- modulo.lua

-- Um módulo em Lua é só um arquivo que DEVOLVE um valor — quase sempre
-- uma tabela com as funções públicas. Quem carrega com require recebe
-- esse valor. Veja o consumo em usando_require.lua.

local M = {}

-- estado interno: privado porque é local ao arquivo (uma clausura):
local totalDeSaudacoes = 0

function M.saudar(nome)
  assert(type(nome) == "string" and nome ~= "", "informe um nome")
  totalDeSaudacoes = totalDeSaudacoes + 1
  return "Olá, " .. nome .. "!"
end

function M.dobrar(numero)
  assert(type(numero) == "number", "informe um número")
  return 2 * numero
end

function M.totalDeSaudacoes()
  return totalDeSaudacoes
end

-- autoteste: roda uma vez, no carregamento (ou na execução direta):
assert(M.saudar("Lua") == "Olá, Lua!")
assert(M.dobrar(21) == 42)
assert(M.totalDeSaudacoes() == 1)

return M
