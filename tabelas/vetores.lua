-- vetores.lua

--------------------------------------------------------------------------------
-- Aspectos essenciais sobre as tabelas de Lua como vetores/listas
--------------------------------------------------------------------------------
-- Inicialização

-- Inicializa um vetor vazio:
local vetorVazio = {}

-- Inicializa um vetor com elementos predefinidos:
local vetorPredefinido = {"maçã","banana", "laranja"}

-- Empacota os elementos em um vetor:
local vetorEmpacotado = table.pack("maçã", "banana", "laranja")
assert(vetorEmpacotado.n == 3 and vetorEmpacotado[1] == "maçã")

--------------------------------------------------------------------------------
-- Acesso aos Elementos

local frutas = {"maçã","banana", "laranja"}

-- Acessando elementos pelo índice:
print(frutas[2]) --> banana
assert(frutas[2] == "banana")

-- O índice começa em 1:
print(frutas[1]) --> maçã
assert(frutas[1] == "maçã")

-- Acessando elementos fora dos limites:
print(frutas[4]) --> nil
print(frutas[0]) --> nil
print(frutas[-1]) --> nil
assert(frutas[4] == nil and frutas[0] == nil and frutas[-1] == nil)


--------------------------------------------------------------------------------
-- Percorrendo Vetores

local frutas = {"maçã","banana", "laranja"}

-- Número de elementos:
print(#frutas) --> 3
assert(#frutas == 3)

-- Percorrendo os elementos usando um intervalo:
for i = 1, #frutas do
  print(frutas[i]) --> maçã, --> banana, --> laranja
end

-- Percorrendo usando ipairs:
for _, fruta in ipairs(frutas) do
  print(fruta) --> maçã, --> banana, --> laranja
end

-- Iterando com next (a ordem de visita NÃO é garantida pelo manual,
-- nem para índices numéricos — use ipairs quando a ordem importar):
local indice, valor = next(frutas)
while indice do
  print(valor) -- visita todos os elementos, em ordem não especificada
  indice, valor = next(frutas, indice)
end

-- Imprime os elementos concatenados:
print(table.concat(frutas, ", ")) --> maçã, banana, laranja
assert(table.concat(frutas, ", ") == "maçã, banana, laranja")

--------------------------------------------------------------------------------
-- Manipulação

local frutas = {"maçã","banana", "laranja"}

-- Modificando elementos:
frutas[2] = "manga"
print(table.concat(frutas, ", ")) --> maçã, manga, laranja
assert(table.concat(frutas, ", ") == "maçã, manga, laranja")

-- Acrescentando elementos:
table.insert(frutas, "kiwi")
print(table.concat(frutas, ", ")) --> maçã, manga, laranja, kiwi
assert(table.concat(frutas, ", ") == "maçã, manga, laranja, kiwi")

-- Inserindo em um índice específico:
table.insert(frutas, 2, "pera")
print(table.concat(frutas, ", ")) --> maçã, pera, manga, laranja, kiwi
assert(table.concat(frutas, ", ") == "maçã, pera, manga, laranja, kiwi")

-- Remove o último elemento:
table.remove(frutas)
print(table.concat(frutas, ", ")) --> maçã, pera, manga, laranja
assert(table.concat(frutas, ", ") == "maçã, pera, manga, laranja")

-- Removendo em um índice específico:
table.remove(frutas, 3)
print(table.concat(frutas, ", ")) --> maçã, pera, laranja
assert(table.concat(frutas, ", ") == "maçã, pera, laranja")

--------------------------------------------------------------------------------
-- Ordenação*

local frutas = {"maçã","pera", "laranja"}

-- Ordenação padrão:
table.sort(frutas)
print(table.concat(frutas, ", ")) --> laranja, maçã, pera
assert(table.concat(frutas, ", ") == "laranja, maçã, pera")

-- Ordenação personalizada:
local ordenacaoPersonalizada = function (a, b) return #a > #b end
table.sort(frutas, ordenacaoPersonalizada)
print(table.concat(frutas, ", ")) --> laranja, maçã, pera
assert(table.concat(frutas, ", ") == "laranja, maçã, pera")

-- Ordenação inversa:
local ordenacaoInversa = function(a, b) return a > b end
table.sort(frutas, ordenacaoInversa)
print(table.concat(frutas, ", ")) --> pera, maçã, laranja
assert(table.concat(frutas, ", ") == "pera, maçã, laranja")

-- *O algoritmo de ordenação não é estável.

--------------------------------------------------------------------------------
-- Mesclando vetores

-- Mescla vetores usando table.insert:
local v1 = {"maçã","banana", "cereja"}
local v2 = {"manga","pera"}
for _, item in ipairs(v2) do
  table.insert(v1, item)
end
print(table.concat(v1, ", ")) --> maçã, banana, cereja, manga, pera
assert(table.concat(v1, ", ") == "maçã, banana, cereja, manga, pera")

-- Mescla vetores usando table.move:
local v1 = {"maçã","banana", "cereja"}
local v2 = {"manga","pera"}
table.move(v2, 1, #v2, #v1+1, v1)
print(table.concat(v1, ", ")) --> maçã, banana, cereja, manga, pera
assert(table.concat(v1, ", ") == "maçã, banana, cereja, manga, pera")

-- Mescla vetores usando table.unpack:
local v2 = {"manga","pera"}
local v1 = {"maçã","banana", "cereja", table.unpack(v2)}
print(table.concat(v1, ", ")) --> maçã, banana, cereja, manga, pera
assert(table.concat(v1, ", ") == "maçã, banana, cereja, manga, pera")

--------------------------------------------------------------------------------
-- Introdução aos vetores multidimensionais

-- Criando uma grade (matriz):
local n = 3
local m = 4
local grade = {}
for i = 1, n do
  grade[i] = {}
  for j = 1, m do
    grade[i][j] = 0
  end
end
assert(#grade == 3 and #grade[1] == 4 and grade[3][4] == 0)

-- Cria um vetor multidimensional:
local matriz = {
  {1, 2, 3},
  {4, 5, 6},
  {7, 8, 9}
}

-- Acessando elementos em vetores multidimensionais:
print(matriz[2][1]) --> 4
assert(matriz[2][1] == 4)


-- Percorrendo um vetor multidimensional:
for i = 1, #matriz do
  for j = 1, #matriz[i] do
    print(matriz[i][j]) --> 1, 2, 3, 4, 5, 6, 7, 8, 9
  end
end

-- Manipulando elementos em vetores multidimensionais:
matriz[2][1] = 99
print(matriz[2][1]) --> 99
assert(matriz[2][1] == 99)

--------------------------------------------------------------------------------
