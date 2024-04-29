-- Lua List/Array Methods

-- Creating a List/Array:
local emptyList = {}
local names = { "ana", "bob", "carlos" }
local fruits = table.pack("apple", "banana", "orange")

-- Unpacking the elements:
local name_1, name_2, name_3 = table.unpack(names)
print(name_2) --> bob

-- Getting the number of elements:
print(#names) --> 3

-- Looping using "for range":
for i=1, #names do print(names[i]) end
--> ana
--> bob
--> carlos

-- Looping using "for in":
for _, name in ipairs(names) do print(name) end
--> ana
--> bob
--> carlos

-- Converting list to string:
local string_list = table.concat(names, ", ")
print(string_list) --> ana, bob, carlos

-- Appending to the list:
table.insert(names, "duda")
print(table.concat(names, ", "))
--> ana, bob, carlos, duda

-- Inserting at a specified position:
table.insert(names, 3, "edu")
print(table.concat(names, ", "))
--> ana, bob, edu, carlos, duda

-- Sorting the list:
table.sort(names)
print(table.concat(names, ", "))
--> ana, bob, carlos, duda, edu

-- Reversing the list:
table.sort(names, function(a, b) return a > b end)
print(table.concat(names, ", "))
--> edu, duda, carlos, bob, ana

-- Removing the last item:
table.remove(names)
print(table.concat(names, ", "))
--> edu, duda, carlos, bob

-- Removing item by position:
table.remove(names, 3)
print(table.concat(names, ", "))
--> edu, duda, bob

-- Merging lists:
table.move(fruits, 1, #fruits, #names+1, names)
print(table.concat(names, ", "))
--> edu, duda, bob, apple, banana, orange

-- Searching on lists:
local this_name = "bob"

local function search_on_list(target, list)
  local indexes = {}
  for i, item in ipairs(list) do
    if item == target then table.insert(indexes, i) end
  end
  return indexes
end

local target_index_list = search_on_list(this_name, names)
print(table.concat(target_index_list, ", ")) --> 3
