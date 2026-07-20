-- operadores.lua

-----------------------------------------------------------------------
-- Operadores Aritméticos:
print(3 + 4)  --> 7
print(3 - 4)  --> -1
print(3 * 4)  --> 12
print(2 ^ 3)  --> 8.0
print(7 / 3)  --> 2.3333333333333
print(7 // 3) --> 2
print(7 % 3)  --> 1
print(-1)     --> -1
assert(3 + 4 == 7 and 3 - 4 == -1 and 3 * 4 == 12)
assert(2 ^ 3 == 8.0 and math.type(2 ^ 3) == "float")
assert(math.type(7 / 3) == "float")
assert(7 // 3 == 2 and 7 % 3 == 1)

-- Operadores Relacionais:
print(3 < 4)  --> true
print(3 > 4)  --> false
print(3 <= 4) --> true
print(3 >= 4) --> false
print(3 == 4) --> false
print(3 ~= 4) --> true
assert((3 < 4) == true and (3 > 4) == false)
assert((3 <= 4) == true and (3 >= 4) == false)
assert((3 == 4) == false and (3 ~= 4) == true)

-----------------------------------------------------------------------
-- Operadores Lógicos:
print(true or false)  --> true
print(true and false) --> false
print(not false)      --> true
assert((true or false) == true)
assert((true and false) == false)
assert((not false) == true)

-----------------------------------------------------------------------
-- Operadores Bit a Bit
print(6 & 3)  --> 2    AND:    (0110 & 0011 = 0010)
print(6 | 3)  --> 7    OR:     (0110 | 0011 = 0111)
print(6 ~ 3)  --> 5    XOR:    (0110 ~ 0011 = 0101)
print(3 << 2) --> 12   lshift: (0011 --> 1100)
print(8 >> 3) --> 1    rshift: (1000 --> 0001)
-- (ilustração truncada em 16 bits; os inteiros de Lua 5.4 têm 64)
print(~3)     --> -4   NOT:    (~0000000000000011 = 1111111111111100)
assert(6 & 3 == 2 and 6 | 3 == 7 and 6 ~ 3 == 5)
assert(3 << 2 == 12 and 8 >> 3 == 1 and ~3 == -4)

-----------------------------------------------------------------------
--                       Operadores Especiais:
-----------------------------------------------------------------------
-- Atribuição:
local nomes = { "ana", "bob" }
local str = "Lua!"
local x = true and "a" or "b"
assert(x == "a")

-----------------------------------------------------------------------
-- comprimento:
print(#nomes)    --> 2
print(#str)      --> 4
print(#"string") --> 6
assert(#nomes == 2 and #str == 4 and #"string" == 6)

-----------------------------------------------------------------------
-- concatenação:
print("Olá " .. str) --> Olá Lua!
assert("Olá " .. str == "Olá Lua!")

-----------------------------------------------------------------------
-- Coerção (conversão automática entre número e string):

-- A aritmética converte strings com formato de número — o resultado é
-- um NÚMERO de verdade (aqui, um inteiro):
print("10" + 5) --> 15
assert("10" + 5 == 15)
assert(math.type("10" + 5) == "integer")

-- A concatenação faz o caminho inverso: converte números para string:
print(42 .. "") --> 42
assert(42 .. "" == "42")
assert(type(42 .. "") == "string")

-- A coerção vale para OPERADORES, não para a igualdade: `==` entre
-- tipos diferentes é sempre false, sem converter nada:
assert(("10" == 10) == false)

-- Para converter de propósito, use tonumber e tostring — explícitos,
-- sem depender de coerção implícita:
assert(tonumber("3.14") == 3.14)
assert(tostring(42) == "42")

-- tonumber aceita uma base (2 a 36)...
assert(tonumber("ff", 16) == 255)
-- ...e devolve nil quando o texto não é um número — por isso serve
-- para validar entrada do usuário:
assert(tonumber("abc") == nil)

-----------------------------------------------------------------------
-- Pertinência:

-- Lua não tem operador "in" para pertinência; o idioma correto é um
-- laço comparando elemento a elemento:

local nomes = { "ana", "bob" }

local function pertence(lista, alvo)
  for _, elemento in ipairs(lista) do
    if elemento == alvo then return true end
  end
  return false
end

assert(pertence(nomes, "bob") == true)
assert(pertence(nomes, "charlie") == false)

-- Pertinência not in:
assert(not pertence(nomes, "charlie"))

-- CONTRAEXEMPLO — evite o atalho concat+find: ele testa SUBSTRING,
-- não elemento. "ana" é substring de "banana", então o teste abaixo
-- daria um falso-positivo:
local outros = { "banana", "carlos" }
assert(table.concat(outros, ","):find("ana") ~= nil) -- "encontrou"...
assert(pertence(outros, "ana") == false)             -- ...mas não pertence!

-----------------------------------------------------------------------
-- Número variável de argumentos:
local function selecionar(n, ...)
  local argumentos = { ... }
  return argumentos[n]
end

print(selecionar(2, "asdf", 42, true)) --> 42
assert(selecionar(2, "asdf", 42, true) == 42)
