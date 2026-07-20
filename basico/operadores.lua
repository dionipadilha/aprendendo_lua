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
-- Pertinência:

local nomes = { "ana", "bob" }

-- Pertinência com for in:
for _, nome in ipairs(nomes) do print(nome) end --> ana, bob

-- Pertinência in:
for _, nome in ipairs(nomes) do
  if nome == "bob" then print(true) end
end
--> true

print(table.concat(nomes, ","):find("bob") and true)     --> true
print(table.concat(nomes, ","):find("charlie") and true) --> nil
assert((table.concat(nomes, ","):find("bob") and true) == true)
assert((table.concat(nomes, ","):find("charlie") and true) == nil)

-- Pertinência not in:
print(not table.concat(nomes, ","):find("bob"))     --> false
print(not table.concat(nomes, ","):find("charlie")) --> true
assert((not table.concat(nomes, ","):find("bob")) == false)
assert((not table.concat(nomes, ","):find("charlie")) == true)

-----------------------------------------------------------------------
-- Número variável de argumentos:
local function selecionar(n, ...)
  local argumentos = { ... }
  return argumentos[n]
end

print(selecionar(2, "asdf", 42, true)) --> 42
assert(selecionar(2, "asdf", 42, true) == 42)
