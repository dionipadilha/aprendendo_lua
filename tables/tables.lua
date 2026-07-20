--------------------------------------------------------------------------------
-- Essential aspects about Lua tables
--------------------------------------------------------------------------------
-- Initialization

-- Initialize an empty table:
local emptyTable = {}

-- Initialize an table with pre-defined elements:
local table = {key1 = "value1", key2 = "value2"}

--------------------------------------------------------------------------------
-- Element Access

-- Accessing elements:
local value = table["key1"]
print(value) --> "value1"

-- Accessing elements outside the range:
local nonExistent = table["nonExistent"]
print(nonExistent) --> nil

-- Looping through elements using ipairs:
for key, value in pairs(table) do
  print(key, value) --> key1 value1, --> key2 value2
end

-- Number of elements:
local count = 0
for _ in pairs(table) do count = count + 1 end
print(count) --> 2

-- Iterating with next function:
local key, value = next(table, nil)
while key do
    print(key, value) --> key1 value1, --> key2 value2
    key, value = next(table, key)
end

--------------------------------------------------------------------------------
-- Manipulation

-- Modifying elements by index:
table["key1"] = "newValue1"

-- Adding new elements:
table["newKey"] = "newValue"

-- Remove element by key:
table["key1"] = nil

--------------------------------------------------------------------------------
-- Merging tables

-- Merge tables using pairs:
local table1 = {a = 1, b = 2}
local table2 = {c = 3, d = 4}
for k, v in pairs(table2) do
    table1[k] = v
end
print(table1.a, table1.b, table1.c, table1.d) --> 1 2 3 4

--------------------------------------------------------------------------------
-- Intro for Multi-dimensional tables

-- Create a multi-dimensional tables:
local multiDimTable = { first = {a = 1, b = 2}, second = {c = 3, d = 4} }

-- Accessing elements in multi-dimensional tables:
local element = multiDimTable["first"]["a"] -- 1

-- Manipulation elements in multi-dimensional tables:
multiDimTable["second"]["d"] = 5

-- Adding new elements in multi-dimensional tables:
multiDimTable["third"] = {e = 6, f = 7}

-- Remove element in multi-dimensional tables:
multiDimTable["first"]["a"] = nil

-- Looping through elements in multi-dimensional tables:
for key, value in pairs(multiDimTable) do
    for k, v in pairs(value) do
        print(k, v)
    end
end
--------------------------------------------------------------------------------
