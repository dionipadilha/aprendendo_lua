-- lua_introducao_rapida.lua

-- Este é um comentário de uma linha
print("Olá, Mundo!") --> comentário lateral

--[[
  Este é um
    comentário de
      várias linhas.
--]]

-- Tipos de Dados:
local numero = 10 -- números reais: ponto flutuante de precisão dupla
local texto = "Lua"
local booleano = true
local lista = {"item1", "item2", "..."} -- lista, array
local tabela = {chave_1 = "str", chave_2 = 30} -- dicionário, mapa
local x = nil -- representa a ausência de valor

-- Condicional:
local n = 10
if n > 5 then print("O número é maior que 5")
  elseif n < 5 then print("O número é menor que 5")
  else print("O número é 5")
end

-- Expressão estilo ternário:
local n = 10
print(n > 5 and n.." é maior que 5" or n.." é menor que 5")

-- Laço com intervalo:
for i = 1, 5 do print(i) end

-- Laço sobre lista:
local estudantes = {"ana", "bob", "carlos"}
for _, estudante in ipairs(estudantes) do
  print(estudante)
end

-- Laço sobre tabela:
local estudante = {nome = "ana", idade = 20}
for chave, valor in pairs(estudante) do
  print(chave, valor)
end

-- Laço while:
local i = 1
while i <= 5 do
  print(i)
  i = i + 1
end

-- Definição básica de função:
local function saudar(nome)
  print("Olá " .. nome)
end
saudar("Alice") --> Olá Alice

-- Tabela como arrays, listas
local lista = {"item1", "item2", "item3"}
print(lista[1]) --> item1 (Lua usa indexação a partir de 1.)

-- Tabela como mapa, dicionário
local tabela = {chave1 = "valor1", chave2 = "valor2"}
print(tabela["chave1"]) --> valor1

-- Tabela como objetos
local pessoa = {nome = "bob", idade = 30}
print(pessoa.nome)  --> bob
print(pessoa.idade)  --> 30

-- Tratamento de erros básico:
local funcao_que_pode_falhar = function() error("Erro") end
if pcall(funcao_que_pode_falhar) then print("Sucesso")
else print("Falha")
end
