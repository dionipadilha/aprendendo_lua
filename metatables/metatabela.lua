-- metatabela.lua

---------------------------------------------------------
-- Sem metatabelas:

local t1 = { 1, 3, 5 }
local t2 = { 2, 4, 6 }

local function juntar(a, b)
  table.move(a, 1, #a, #b + 1, b)
  table.sort(b)
  return table.concat(b, ", ")
end

print(juntar(t1, t2)) --> 1, 2, 3, 4, 5, 6
-- print(t1 + t2)     --> erro

---------------------------------------------------------
-- Metatabelas: personalizam o comportamento das tabelas Lua.

local t3 = { 1, 3, 5 }
local t4 = { 2, 4, 6 }

local mt = {
  __add = juntar
}

setmetatable(t3, mt) --> ou setmetatable(t4, mt)
print(t3 + t4)       --> 1, 2, 3, 4, 5, 6
---------------------------------------------------------
