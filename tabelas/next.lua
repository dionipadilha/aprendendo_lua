-- next.lua

-------------------------------------------------------
-- retorna o próximo par chave-valor da tabela:
local frutas = { "maçã", "banana", "laranja" }

local indice, valor = next(frutas)
print(indice, valor) --> 1	maçã

indice, valor = next(frutas, indice)
print(indice, valor) --> 2	banana


indice, valor = next(frutas, indice)
print(indice, valor) --> 3	laranja

indice, valor = next(frutas, indice)
print(indice, valor) --> nil	nil

-------------------------------------------------------
-- laço while usando next:
local nomes = { "ana", "bob", "charlie" }

local i, nome = next(nomes)
while i do
  print(nome)
  i, nome = next(nomes, i)
end

-------------------------------------------------------
