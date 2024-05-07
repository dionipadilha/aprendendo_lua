-- iterators.lua

-------------------------------------------------------
-- returns the next value in the table:
local function list_iterator(t)
  local i = 0
  return function()
    i = i + 1
    if i <= #t then return t[i] end
  end
end

-------------------------------------------------------
local fruits = { "apple", "banana", "cherry" }
local next_fruit = list_iterator(fruits)
print(next_fruit()) --> apple
print(next_fruit()) --> banana
print(next_fruit()) --> cherry
print(next_fruit()) -->

-------------------------------------------------------
local names = { "ana", "bob", "charlie" }
for name in list_iterator(names) do print(name) end

-------------------------------------------------------
local students = { "ana", "bob", "charlie" }
local students_list = list_iterator(students)
for name in students_list do print(name) end
