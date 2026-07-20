-- inverter_tabela.lua

-- Exercício 4 de documentacao/comece_aqui.md: uma lista nova com os
-- elementos na ordem contrária, sem modificar a original.
-- Tente resolver sozinho antes de ler!

local function inverter(lista)
  local invertida = {}
  for posicao = #lista, 1, -1 do
    table.insert(invertida, lista[posicao])
  end
  return invertida
end

-- Verificação:
local original = { "a", "b", "c" }
local resultado = inverter(original)

assert(table.concat(resultado, "") == "cba")
assert(table.concat(original, "") == "abc") -- a original está intacta
assert(resultado ~= original)               -- é uma tabela NOVA, não a mesma
assert(#inverter({}) == 0)                  -- lista vazia devolve lista vazia

print("inverter tabela: solução verificada!")
