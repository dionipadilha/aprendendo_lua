--------------------------------------------------------------------------------
-- Essential aspects about Lua tables as arrays/lists
--------------------------------------------------------------------------------
-- Initialization

-- Initialize an empty array:
local emptyArray = {}

-- Initialize an array with pre-defined elements:
local predefinedArray = {"apple","banana", "orange"}

-- Pack the elements into an array:
local packedArray = table.pack("apple", "banana", "orange")

--------------------------------------------------------------------------------
-- Element Access

local fruits = {"apple","banana", "orange"}

-- Accessing elements:
print(fruits[1]) --> apple

-- Accessing elements outside the range:
print(fruits[4]) --> nil
print(fruits[0]) --> nil
print(fruits[-1]) --> nil

-- Number of elements:
print(#fruits) --> 3

-- Looping through elements using range:
for i = 1, #fruits do
  print(fruits[i]) --> apple, --> banana, --> orange
end

-- Looping through elements using ipairs:
for _, fruit in ipairs(fruits) do
  print(fruit) --> apple, --> banana, --> orange
end

-- Iterating with next function:
local index, value = next(fruits)
while index do
  print(value) --> apple, --> banana, --> orange
  index, value = next(fruits, index)
end

-- Show concatenate elements:
print(table.concat(fruits, ", ")) --> apple, banana, orange

--------------------------------------------------------------------------------
-- Manipulation

local fruits = {"apple","banana", "orange"}

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
-- Sort Elements*

local fruits = {"apple","pear", "orange"}

-- Default sort:
table.sort(fruits)
print(table.concat(fruits, ", ")) --> apple, orange, pear

-- Reverse sort:
local ReverseSort = function(a, b) return a > b end
table.sort(fruits, ReverseSort)
print(table.concat(fruits, ", ")) --> pear, orange, apple

-- Custom sort:
local customSort = function (a, b) return #a > #b end
table.sort(fruits, customSort)
print(table.concat(fruits, ", ")) --> pear, apple, orange

-- *The sort algorithm is not stable.
-- see more about sort arrays on sort_arrays.lua

--------------------------------------------------------------------------------
-- Merging arrays

-- Merge arrays using table.insert:
local a1 = {"apple","banana", "cherry"}
local a2 = {"mango","pear"}
for _, item in ipairs(a2) do
  table.insert(a1, item)
end
print(table.concat(a1, ", ")) --> apple, banana, cherry, mango, pear

-- Merge arrays using table.move:
local a1 = {"apple","banana", "cherry"}
local a2 = {"mango","pear"}
table.move(a2, 1, #a2, #a1+1, a1)
print(table.concat(a1, ", ")) --> apple, banana, cherry, mango, pear

-- Merge arrays using table.unpack:
local a2 = {"mango","pear"}
local a1 = {"apple","banana", "cherry", table.unpack(a2)}
print(table.concat(a1, ", ")) --> apple, banana, cherry, mango, pear

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
