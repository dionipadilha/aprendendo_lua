-- next.lua

-------------------------------------------------------
local fruits = { "apple", "banana", "orange" }

local index, value = next(fruits)
print(index, value) --> 1	apple

index, value = next(fruits, index)
print(index, value) --> 2	banana


index, value = next(fruits, index)
print(index, value) --> 2	banana

index, value = next(fruits, index)
print(index, value) --> nil	nil

-------------------------------------------------------
local fruits = { "apple", "banana", "orange" }

local index, value = next(fruits)
while index do
  print(value)
  index, value = next(fruits, index)
end

-------------------------------------------------------
local fruits = { "apple", "banana", "orange" }
for _, fruit in next, fruits do
  print(fruit)
end
