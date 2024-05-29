-- multiple_inheritance.lua

-- Define Mixins:

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

-- copy all methods from the provided mixins into the target instance:
local function mixin(target, ...)
  local classes = { ... }
  for _, class in ipairs(classes) do
    for k, v in pairs(class) do target[k] = v end
  end
end

-- Create a Class that Inherits from Mixins:
local MyClass = {}

function MyClass:new(instance)
  self.__index = self
  mixin(self, ClassA, ClassB)
  instance = instance or {}
  return setmetatable(instance, self)
end

-- Call methods from mixins
local instance = MyClass:new()
assert(instance:fA() == "A")
assert(instance:fB() == "B")
