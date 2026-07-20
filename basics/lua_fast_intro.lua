-- lua_fast_intro.lua

-- This is a single line comment
print("Hello, World!") --> side comment

--[[
  This is a
    multi-line
      comment.
--]]

-- Data Types:
local number = 10 -- real numbers: double-precision floating-point
local string = "Lua"
local boolean = true
local list = {"item1", "item2", "..."} -- list, array
local table = {key_1 = "str", key_2 = 30} -- dictionary, map
local x = nil -- represents absence of value

-- Conditional:
local n = 10
if n > 5 then print("Number is greater than 5")
  elseif n < 5 then print("Number is less than 5")
  else print("Number is 5")
end

-- Ternary-like expression:
local n = 10
print(n > 5 and n.." is greater than 5" or n.." is less than 5")

-- Range loop:
for i = 1, 5 do print(i) end

-- List loop:
local students = {"ana", "bob", "carlos"}
for _, student in ipairs(students) do
  print(student)
end

-- Table loop:
local student = {name = "ana", age = 20}
for key, value in pairs(student) do
  print(key, value)
end

-- While loop:
local i = 1
while i <= 5 do
  print(i)
  i = i + 1
end

-- Basic Function definition:
local function greet(name)
  print("Hello " .. name)
end
greet("Alice") --> Hello Alice

-- Table like arrays, list
local list = {"item1", "item2", "item3"}
print(list[1]) --> item1 (Lua uses 1-based indexing.)

-- Table like map, dictionary
local table = {key1 = "value1", key2 = "value2"}
print(table["key1"]) --> value1

-- Table like objects
local person = {name = "bob", age = 30}
print(person.name)  --> bob
print(person.age)  --> 30

-- Basic error handling:
local function_that_might_fail = function() error("Error") end
if pcall(function_that_might_fail) then print("Success")
else print("Failure")
end
