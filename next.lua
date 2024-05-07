-- next.lua

-------------------------------------------------------
-- returns the next key-value pair in the table:
local fruits = { "apple", "banana", "orange" }

local index, value = next(fruits)
print(index, value) --> 1	apple

index, value = next(fruits, index)
print(index, value) --> 2	banana


index, value = next(fruits, index)
print(index, value) --> 3	orange

index, value = next(fruits, index)
print(index, value) --> nil	nil

-------------------------------------------------------
-- while loop using next:
local names = { "ana", "bob", "charlie" }

local i, name = next(names)
while i do
  print(name)
  i, name = next(names, i)
end

-------------------------------------------------------
