-- multiple_inheritance.lua

-- #1. Define multiple classes:

local ClassA = {
  fA = function(self)
    return "A"
  end
}

local ClassB = {
  fB = function(self)
    return "B"
  end
}

-- #2. Utility function: mixin all methods from the multiple classes:
local function mixin(target, ...)
  local classes = { ... }
  for _, class in ipairs(classes) do
    for k, v in pairs(class) do target[k] = v end
  end
end

-- #3. Create a class that inherits from multiple classes:
local MyClass = {}

function MyClass:new(instance)
  self.__index = self
  mixin(self, ClassA, ClassB)
  instance = instance or {}
  return setmetatable(instance, self)
end

-- Testing: Call methods from multiple classes:
local instance = MyClass:new()
assert(instance:fA() == "A")
assert(instance:fB() == "B")
