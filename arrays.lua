--------------------------------------------------------------------------------
-- Essential aspects about Lua tables as arrays/lists
--------------------------------------------------------------------------------
-- Initialization

-- Initialize an empty array:
local fruits = {}

-- Initialize an array with pre-defined elements:
local fruits = {"apple","banana", "orange"}

-- Pack the elements into an array:
local fruits = table.pack("apple", "banana", "orange")

--------------------------------------------------------------------------------
-- Element Access

local fruits = {"apple","banana", "orange"}

-- Number of elements:
print(#fruits) --> 3

-- Accessing elements:
print(fruits[1]) --> apple

-- Accessing elements outside the range:
print(fruits[4]) --> nil
print(fruits[0]) --> nil
print(fruits[-1]) --> nil

-- Looping through elements using #:
for i = 1, #fruits do
  print(fruits[i]) --> apple, --> banana, --> orange
end

-- Looping through elements using ipairs:
for _, fruit in ipairs(fruits) do
  print(fruit) --> apple, --> banana, --> orange
end

-- Iterating with next:
local index, value = next(fruits)
while index do
  print(value) --> apple, --> banana, --> orange
  index, value = next(fruits, index)
end

-- Show concatenate elements:
print(table.concat(fruits, ", ")) --> apple, banana, orange

--------------------------------------------------------------------------------
-- Manipulation

-- Modifying elements by index:
fruits[2] = "mango"
print(table.concat(fruits, ", ")) --> apple, mango, orange

-- Appending elements:
table.insert(fruits, "kiwi")
print(table.concat(fruits, ", ")) --> apple, mango, orange, kiwi

-- Insert element at specific index:
table.insert(fruits, 2, "pear")
print(table.concat(fruits, ", ")) --> apple, pear, mango, orange, kiwi

-- Remove last element:
table.remove(fruits)
print(table.concat(fruits, ", ")) --> apple, pear, mango, orange

-- Remove element at specific index:
table.remove(fruits, 3)
print(table.concat(fruits, ", ")) --> apple, pear, orange

--------------------------------------------------------------------------------
-- Sort Elements
-- * The sort algorithm is not stable.

local fruits = {"apple","pear", "orange"}

-- Default sort:
table.sort(fruits)
print(table.concat(fruits, ", ")) --> apple, orange, pear

-- Reverse sort with anonymous functions:
local ReverseSort = function(a, b) return a > b end
table.sort(fruits, ReverseSort)
print(table.concat(fruits, ", ")) --> pear, orange, apple

-- Custom sort with anonymous functions:
local customSort = function (a, b) return #a > #b end
table.sort(fruits, customSort)
print(table.concat(fruits, ", ")) --> pear, apple, orange

-- see more about sort arrays on sort_arrays.lua

--------------------------------------------------------------------------------
-- Merging Elements

-- Merge the elements into the first array #1:
local a1 = {1, 2, 3}
local a2 = {4, 5, 6}
for _, item in ipairs(a2) do
  table.insert(a1, item)
end
print(table.concat(a1, ", ")) --> 1, 2, 3, 4, 5, 6

-- Merge the elements into the first array #3:
local a1 = {1, 2, 3}
local a2 = {4, 5, 6}
table.insert(a1, table.unpack(a2))
print(table.concat(a1, ", ")) --> 1, 2, 3, 4, 5, 6

-- Merge the elements into the first array #2:
local a1 = {1, 2, 3}
local a2 = {4, 5, 6}
table.move(a2, 1, #a2, #a1+1, a1)
print(table.concat(a1, ", ")) --> 1, 2, 3, 4, 5, 6

-- see more about merge arrays on merge_arrays.lua

--------------------------------------------------------------------------------
-- Intro for Multi-dimensional Arrays

-- Create a multi-dimensional arrays:
local matrix = {
  {1, 2, 3},
  {4, 5, 6},
  {7, 8, 9}
}

-- Accessing elements in multi-dimensional arrays:
print(matrix[2][1]) --> 4

-- Manipulation elements in multi-dimensional arrays:
matrix[2][1] = 99
print(matrix[2][1]) --> 99

-- see more about multi-dimensional arrays on multidimensional.lua

--------------------------------------------------------------------------------
