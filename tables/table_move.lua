-- table_move.lua

-- Define source and target tables:
local source = { 1, 2, 3, 4 }
local target = { "a", "b", "c", "d" }

-- Move elements from the source to the target table:
table.move(source, 1, #source, 2, target)

-- Print target table with moved elements:
print(table.concat(target, ", ")) --> a, 1, 2, 3, 4
