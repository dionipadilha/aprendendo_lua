-- next.lua

-------------------------------------------------------
-- next(t, chave) retorna o próximo par chave-valor da tabela
-- (e next(t) retorna o primeiro). ATENÇÃO: o manual não especifica
-- a ORDEM da enumeração, nem mesmo para índices numéricos — o que é
-- garantido é que cada par é visitado exatamente uma vez.
local frutas = { "maçã", "banana", "laranja" }

-- percorre a tabela inteira com next, colecionando o que visitou:
local visitados = {}
local indice, valor = next(frutas)
while indice do
  print(indice, valor)
  visitados[indice] = valor
  indice, valor = next(frutas, indice)
end

-- o CONJUNTO visitado é garantido (a ordem, não):
assert(visitados[1] == "maçã")
assert(visitados[2] == "banana")
assert(visitados[3] == "laranja")

-- a enumeração termina quando next devolve nil — foi isso que
-- encerrou o while acima (indice terminou nil):
assert(indice == nil and valor == nil)

-- next também é o jeito idiomático de testar se uma tabela está vazia:
assert(next({}) == nil)
assert(next(frutas) ~= nil)

-------------------------------------------------------
-- laço while usando next:
local nomes = { "ana", "bob", "charlie" }

local contagem = 0
local i, nome = next(nomes)
while i do
  print(nome)
  contagem = contagem + 1
  i, nome = next(nomes, i)
end
assert(contagem == 3) -- visitou todos os elementos

print("enumeração com next verificada!")
