-- overriding.lua

-- #1. Abstract class:
local Class = {}

function Class:new(instance)
  self.__index = self
  instance = instance or {}
  return setmetatable(instance, self)
end

function Class:super(class, methodName, ...)
  if class and class[methodName] then
    return class[methodName](self, ...)
  else
    error("Superclass method not found: " .. tostring(methodName))
  end
end

-- #2. Define ClassA with a greet method:
local ClassA = Class:new {
  greet = function(self)
    return "Hello from ClassA"
  end
}

-- #3. Define ClassB that inherits from ClassA and overrides greet method
local ClassB = ClassA:new {}

function ClassB:greet()
  return self:super(ClassA, "greet") .. " and welcome from ClassB"
end

-- #4. Testing
local instanceA = ClassA:new {}
print(instanceA:greet()) --> Hello from ClassA

local instanceB = ClassB:new {}
print(instanceB:greet()) --> Hello from ClassA and welcome from ClassB
