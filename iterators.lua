-- iterators.lua

-------------------------------------------------------
-- returns the next value in the table:
local function list_iter(t)
  local i = 0
  return function()
    i = i + 1
    if i <= #t then
      return t[i]
    else
      return nil
    end
  end
end

-------------------------------------------------------
local fruits = { "apple", "banana", "cherry" }
local next_fruit = list_iter(fruits)
print(next_fruit()) --> apple
print(next_fruit()) --> banana
print(next_fruit()) --> cherry
print(next_fruit()) --> nil

-------------------------------------------------------
local names = { "ana", "bob", "charlie" }
local next_name = list_iter(names)
print(next_name()) --> ana
print(next_name()) --> bob
print(next_name()) --> charlie
print(next_name()) --> nil

-------------------------------------------------------
