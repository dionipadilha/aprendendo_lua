-- maior_da_lista.lua

-- Exercício 2 de documentacao/comece_aqui.md: o maior número de uma
-- lista, sem math.max. Tente resolver sozinho antes de ler!

local function maiorDaLista(numeros)
  assert(#numeros > 0, "a lista não pode ser vazia")
  local maior = numeros[1]
  for _, numero in ipairs(numeros) do
    if numero > maior then
      maior = numero
    end
  end
  return maior
end

-- Verificação:
assert(maiorDaLista({ 3, 1, 4, 1, 5 }) == 5)
assert(maiorDaLista({ -7, -2, -9 }) == -2) -- funciona com todos negativos
assert(maiorDaLista({ 42 }) == 42)         -- lista de um elemento
assert(not pcall(maiorDaLista, {}))        -- lista vazia é rejeitada

print("maior da lista: solução verificada!")
