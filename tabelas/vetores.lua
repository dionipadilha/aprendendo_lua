-- vetores.lua

--------------------------------------------------------------------------------
-- PAPEL deste arquivo: operações BÁSICAS de array — criação, acesso por
-- índice, percurso, manipulação direta pelos índices e matrizes. Para o
-- tour da biblioteca table (insert, remove, sort, move, concat), veja
-- biblioteca_de_tabelas.lua; para a lista como TAD com operações
-- nomeadas, veja lista.lua.
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
-- nem para índices numéricos — use ipairs quando a ordem importar).
-- A parada compara com nil porque false é chave válida — veja next.lua:
local indice, valor = next(frutas)
while indice ~= nil do
  print(valor) -- visita todos os elementos, em ordem não especificada
  indice, valor = next(frutas, indice)
end

-- Imprime os elementos concatenados:
print(table.concat(frutas, ", ")) --> maçã, banana, laranja
assert(table.concat(frutas, ", ") == "maçã, banana, laranja")

--------------------------------------------------------------------------------
-- Manipulação direta pelos índices

local frutas = {"maçã","banana", "laranja"}

-- Modificando elementos:
frutas[2] = "manga"
print(table.concat(frutas, ", ")) --> maçã, manga, laranja
assert(table.concat(frutas, ", ") == "maçã, manga, laranja")

-- Acrescentando ao fim (#frutas + 1 é a primeira posição livre):
frutas[#frutas + 1] = "kiwi"
print(table.concat(frutas, ", ")) --> maçã, manga, laranja, kiwi
assert(table.concat(frutas, ", ") == "maçã, manga, laranja, kiwi")

-- Removendo o último elemento (atribuir nil apaga a posição):
frutas[#frutas] = nil
print(table.concat(frutas, ", ")) --> maçã, manga, laranja
assert(table.concat(frutas, ", ") == "maçã, manga, laranja")

-- Para inserir/remover em posições intermediárias (deslocando os
-- demais), ordenar e mesclar vetores, use a API table.* — todas essas
-- operações estão demonstradas em biblioteca_de_tabelas.lua.

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
