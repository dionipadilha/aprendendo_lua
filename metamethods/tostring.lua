-- tostring.lua

-----------------------------------------------------------------------------
-- __tostring:
--  customize string representations of tables

-- #1. Default table representation:
local defaultTable = {}
print(defaultTable) --> table id(memory address of the table)

-- #2. Custom table representation:
local customTable = setmetatable({}, {
  __tostring = function() return 'custom tostring behavior!' end
})
print(customTable) --> custom tostring behavior!

-- #3.Print elements in a table:
local names = setmetatable(
  { "ana", "bob", "charlie" },
  { __tostring = function(self) return table.concat(self, ", ") end }
)
print(names) --> ana, bob, charlie

-----------------------------------------------------------------------------
-- Applying the concept:

local Product = {
  name = "",
  price = 0,
  __tostring = function(self)
    return string.format("| %s | $%.2f", self.name, self.price)
  end
}

function Product:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

local Products = {
  Product:new { name = "T-Shirt", price = 19.99 },
  Product:new { name = "Coffee Mug", price = 8.50 }
}

print("Products:")
for n, product in ipairs(Products) do print(n, product) end
--> 1	| T-Shirt| $19.99
--> 2	| Coffee Mug| $8.50
-----------------------------------------------------------------------------
