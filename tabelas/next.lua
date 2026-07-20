-- next.lua

-------------------------------------------------------
-- retorna o próximo par chave-valor da tabela:
local frutas = { "maçã", "banana", "laranja" }

local indice, valor = next(frutas)
print(indice, valor) --> 1	maçã
assert(indice == 1 and valor == "maçã")

indice, valor = next(frutas, indice)
print(indice, valor) --> 2	banana
assert(indice == 2 and valor == "banana")


indice, valor = next(frutas, indice)
print(indice, valor) --> 3	laranja
assert(indice == 3 and valor == "laranja")

indice, valor = next(frutas, indice)
print(indice, valor) --> nil	nil
assert(indice == nil and valor == nil)

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

-------------------------------------------------------
