-- lua_introducao_rapida.lua

-- Este é um comentário de uma linha
print("Olá, Mundo!") --> comentário lateral

--[[
  Este é um
    comentário de
      várias linhas.
--]]

-- Operações aritméticas básicas:
local soma = 1 + 1
local diferenca = 10 - 4
local produto = 7 * 6
local quociente = 20 / 5 -- a divisão `/` sempre produz float
local resto = 10 % 3
assert(soma == 2 and diferenca == 6 and produto == 42)
assert(quociente == 4.0 and resto == 1)

-- Tipos de Dados:
local numero = 10 -- number (Lua 5.4 distingue inteiros de floats, ex.: 3.14)
local texto = "Lua"
local booleano = true
local lista = {"item1", "item2", "..."} -- lista, array
local dicionario = {chave1 = "str", chave2 = 30} -- dicionário, mapa
local x = nil -- representa a ausência de valor

-- Tabela aninhada descrevendo um registro:
local pessoa = {
  amigos = { "Ana", "Charlie" },  -- tabela (lista)
  nome = "Bob",                   -- string
  idade = 42,                     -- número (inteiro)
  altura = 1.82,                  -- número (float)
  ehAdulto = true,                -- booleano
  comer = function(comida) end    -- função
}

-- A notação de dois-pontos define um método (recebe self implícito):
function pessoa:digaOi() return ("Oi, meu nome é " .. self.nome) end
print(pessoa:digaOi()) --> Oi, meu nome é Bob
assert(pessoa:digaOi() == "Oi, meu nome é Bob")

-- Condicional:
local n = 10
if n > 5 then print("O número é maior que 5")
  elseif n < 5 then print("O número é menor que 5")
  else print("O número é 5")
end

-- Expressão estilo ternário:
print(n > 5 and n.." é maior que 5" or n.." é menor que 5") --> 10 é maior que 5
assert((n > 5 and "maior" or "menor") == "maior")

-- Laço com intervalo:
for i = 1, 5 do print(i) end

-- Laço sobre lista:
local estudantes = {"ana", "bob", "carlos"}
for _, estudante in ipairs(estudantes) do
  print(estudante)
end

-- Laço sobre tabela (a ordem de pairs não é garantida):
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
assert(i == 6)

-- Laço repeat (executa o corpo ao menos uma vez):
local tentativas = 0
repeat
  tentativas = tentativas + 1
until tentativas >= 3
assert(tentativas == 3)

-- Definição básica de função:
local function saudar(nome)
  print("Olá " .. nome)
end
saudar("Alice") --> Olá Alice

-- Outras formas de definir funções:
local function maisUm(y) return y + 1 end
local dobro = function(y) return 2 * y end -- função anônima
assert(maisUm(3) == 4)
assert(dobro(5) == 10)

-- Tabela como arrays, listas
local itens = {"item1", "item2", "item3"}
print(itens[1]) --> item1 (Lua usa indexação a partir de 1.)
assert(itens[1] == "item1")

-- Tabela como mapa, dicionário
local mapa = {chave1 = "valor1", chave2 = "valor2"}
print(mapa["chave1"]) --> valor1
assert(mapa.chave1 == "valor1")

-- Tabela como objeto (campos acessados com ponto):
print(pessoa.nome)  --> Bob
print(pessoa.idade) --> 42
assert(pessoa.nome == "Bob" and pessoa.idade == 42)

-- Operações de lista da biblioteca table:
local amigos = table.pack("Charlie", "Ana") -- {"Charlie", "Ana", n = 2}
-- (o campo n de table.pack não é atualizado pelos insert/remove abaixo;
--  aqui só usamos os elementos da lista — ver multiplos_retornos.lua)
table.insert(amigos, "Bob")                 -- {"Charlie", "Ana", "Bob"}
table.insert(amigos, 2, "Alex")             -- {"Charlie", "Alex", "Ana", "Bob"}
table.sort(amigos)                          -- {"Alex", "Ana", "Bob", "Charlie"}
table.remove(amigos)                        -- remove o último ("Charlie")
table.remove(amigos, 1)                     -- remove o primeiro ("Alex")
print(table.concat(amigos, ", ")) --> Ana, Bob
assert(table.concat(amigos, ", ") == "Ana, Bob")
local primeiro, segundo = table.unpack(amigos)
print(segundo) --> Bob
assert(primeiro == "Ana" and segundo == "Bob")

-- Tratamento de erros básico com pcall:
local funcaoQuePodeFalhar = function() error("Erro") end
if pcall(funcaoQuePodeFalhar) then print("Sucesso")
else print("Falha")
end
--> Falha
assert(pcall(funcaoQuePodeFalhar) == false)

-- assert lança um erro quando a condição é falsa:
local function entrada(visitante)
  assert(visitante.ehAdulto, "Acesso negado")
  return "Acesso permitido"
end

local sucesso, resultado = pcall(entrada, pessoa)
print(sucesso, resultado) --> true	Acesso permitido
assert(sucesso == true and resultado == "Acesso permitido")

local menor = { ehAdulto = false }
local sucessoMenor, erroMenor = pcall(entrada, menor)
-- a mensagem vem prefixada com a posição "arquivo:linha" do erro:
print(sucessoMenor, erroMenor) --> false	lua_introducao_rapida.lua:137: Acesso negado
assert(sucessoMenor == false)
assert(string.find(erroMenor, "Acesso negado"))

-- Manipulação de arquivos:
local arquivo = assert(io.open("arquivo_demo.txt", "w"))
arquivo:write("torrada!")
assert(arquivo:close())

arquivo = assert(io.open("arquivo_demo.txt"))
local conteudo = arquivo:read()
print(conteudo) --> torrada!
assert(conteudo == "torrada!")
assert(arquivo:close())

-- remove o arquivo da demonstração (sem deixar lixo para trás):
assert(os.remove("arquivo_demo.txt"))
