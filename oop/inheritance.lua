-- inheritance.lua

-- Defining Parent and Child Tables:
local parent_table = { parent_key = "parent_value" }
local child_table = { child_key = "child_value" }

-- Setting Up Inheritance:
setmetatable(child_table, { __index = parent_table })

-- Accessing the Inherited Key:
print(child_table.child_key)  --> child_value
print(child_table.parent_key) --> parent_value
