-- Métodos de Lista/Vetor em Lua

-- Criando uma Lista/Vetor:
local listaVazia = {}
local nomes = { "ana", "bob", "carlos" }
local frutas = table.pack("maçã", "banana", "laranja")

-- Desempacotando os elementos:
local nome_1, nome_2, nome_3 = table.unpack(nomes)
print(nome_2) --> bob

-- Obtendo o número de elementos:
print(#nomes) --> 3

-- Percorrendo usando "for" com intervalo:
for i=1, #nomes do print(nomes[i]) end
--> ana
--> bob
--> carlos

-- Percorrendo usando "for in":
for _, nome in ipairs(nomes) do print(nome) end
--> ana
--> bob
--> carlos

-- Convertendo a lista em string:
local lista_como_string = table.concat(nomes, ", ")
print(lista_como_string) --> ana, bob, carlos

-- Acrescentando à lista:
table.insert(nomes, "duda")
print(table.concat(nomes, ", "))
--> ana, bob, carlos, duda

-- Inserindo em uma posição específica:
table.insert(nomes, 3, "edu")
print(table.concat(nomes, ", "))
--> ana, bob, edu, carlos, duda

-- Ordenando a lista:
table.sort(nomes)
print(table.concat(nomes, ", "))
--> ana, bob, carlos, duda, edu

-- Invertendo a lista:
table.sort(nomes, function(a, b) return a > b end)
print(table.concat(nomes, ", "))
--> edu, duda, carlos, bob, ana

-- Removendo o último item:
table.remove(nomes)
print(table.concat(nomes, ", "))
--> edu, duda, carlos, bob

-- Removendo um item pela posição:
table.remove(nomes, 3)
print(table.concat(nomes, ", "))
--> edu, duda, bob

-- Mesclando listas:
table.move(frutas, 1, #frutas, #nomes+1, nomes)
print(table.concat(nomes, ", "))
--> edu, duda, bob, maçã, banana, laranja

-- Buscando em listas:
local este_nome = "bob"

local function buscar_na_lista(alvo, lista)
  local indices = {}
  for i, item in ipairs(lista) do
    if item == alvo then table.insert(indices, i) end
  end
  return indices
end

local lista_de_indices_do_alvo = buscar_na_lista(este_nome, nomes)
print(table.concat(lista_de_indices_do_alvo, ", ")) --> 3
