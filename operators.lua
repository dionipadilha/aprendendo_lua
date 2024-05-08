-- operators.lua

-----------------------------------------------------------------------
-- Arithmetic Operators:
print(3 + 4)  --> 7
print(3 - 4)  --> -1
print(3 * 4)  --> 12
print(2 ^ 3)  --> 8.0
print(7 / 3)  --> 2.3333333333333
print(7 // 3) --> 2
print(7 % 3)  --> 1
print(-1)     --> -1

-- Relational Operators:
print(3 < 4)  --> true
print(3 > 4)  --> false
print(3 <= 4) --> true
print(3 >= 4) --> false
print(3 == 4) --> false
print(3 ~= 4) --> true

-----------------------------------------------------------------------
-- Logical Operators:
print(true or false)  --> true
print(true and false) --> false
print(not false)      --> true

-----------------------------------------------------------------------
-- Bitwise Operators
print(6 & 3)  --> 2    AND:    (0110 & 0011 = 0010)
print(6 | 3)  --> 7    OR:     (0110 | 0011 = 0111)
print(6 ~ 3)  --> 5    XOR:    (0110 ~ 0101 = 0101)
print(3 << 2) --> 16   lshift: (0011 --> 1100)
print(8 >> 3) --> 1    rshift: (1000 --> 0001)
print(~3)     --> -4   NOT:    (~0000000000000011 = 1111111111111100)

-----------------------------------------------------------------------
--                       Especial Operators:
-----------------------------------------------------------------------
-- Assignment:
local names = { "ana", "bob" }
local str = "Lua!"
local x = true and "a" or "b"

-----------------------------------------------------------------------
-- length:
print(#names)    --> 2
print(#str)      --> 4
print(#"string") --> 6

-----------------------------------------------------------------------
-- concatenation:
print("Hello " .. str) --> Hello Lua!


-----------------------------------------------------------------------
-- Membership:

local names = { "ana", "bob" }

-- Membership for in:
for _, name in ipairs(names) do print(name) end --> ana, bob

-- Membership in:
for _, name in ipairs(names) do
  if name == "bob" then print(true) end
end
--> true

print(table.concat(names, ","):find("bob") and true)     --> true
print(table.concat(names, ","):find("charlie") and true) --> nil

-- Membership not in:
print(not table.concat(names, ","):find("bob"))     --> false
print(not table.concat(names, ","):find("charlie")) --> true

-----------------------------------------------------------------------
-- Variable number of arguments:
local function select(n, ...)
  arg = { ... }
  return arg[n]
end

print(select(2, "asdf", 42, true))
