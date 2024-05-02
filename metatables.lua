-- Metatables: customize the behavior of Lua tables.

---------------------------------------------------------
-- Without metatables:

local t1 = { 1, 3, 5 }
local t2 = { 2, 4, 6 }

local function union(a, b)
  table.move(a, 1, #a, #b + 1, b)
  table.sort(b)
  return table.concat(b, ", ")
end

print(union(t1, t2)) --> 1, 2, 3, 4, 5, 6
-- print(t1 + t2)    --> error

---------------------------------------------------------
-- Using metatables:

local t3 = { 1, 3, 5 }
local t4 = { 2, 4, 6 }

local mt = {
  __add = union
}

setmetatable(t3, mt) --> or setmetatable(t4, mt)
print(t3 + t4)       --> 1, 2, 3, 4, 5, 6
---------------------------------------------------------
