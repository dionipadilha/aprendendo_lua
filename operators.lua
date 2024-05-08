-- operators.lua

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

-- Logical Operators:
print(true or false)  --> true
print(true and false) --> false
print(not false)      --> true

-- Bitwise Operators


-- Especial Operators:
print("Hello " .. "World")          --> Hello World
print(#"Hello")                     --> 5
print(#{ "ana", "bob", "charlie" }) --> 3
local function temp(...) end
