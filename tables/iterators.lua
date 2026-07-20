-- iterators.lua

-------------------------------------------------------
-- returns the next value in the table:
local function list_iterator(t)
  local i = 0
  local n = #t
  return function()
    i = i + 1
    if i <= n then return t[i] end
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
local students = { "ana", "bob", "charlie" }
local next_student = list_iterator(students)
local student = next_student()
while student do
  print(student)
  student = next_student()
end

-------------------------------------------------------
local names = { "ana", "bob", "charlie" }
for name in list_iterator(names) do print(name) end
