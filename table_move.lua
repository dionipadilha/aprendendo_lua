-- table_move.lua

-- Define source and target tables:
local source = { 1, 2, 3, 4 }
local target = { "a", "b", "c", "d" }

-- Move elements from the source to the target table:
table.move(source, 1, #source, 1, target)
print(table.concat(target, ", ")) --> 1, 2, 3, 4
