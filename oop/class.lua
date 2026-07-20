-- class.lua

-- abstract class:
local Class = {}

function Class:new(instance)
  self.__index = self
  instance = instance or {}
  return setmetatable(instance, self)
end

function Class:mixin(...)
  local classes = { ... }
  for _, class in ipairs(classes) do
    for k, v in pairs(class) do
      if not self[k] then self[k] = v end
    end
  end
end

function Class:hasProperty(propertyName)
  return self[propertyName]
end

function Class:super(class, methodName, ...)
  if class and class[methodName] then
    return class[methodName](self, ...)
  else
    error("Superclass method not found: " .. tostring(methodName))
  end
end

-- Testing

-- #1. Define multiple classes:
local ClassA = Class:new {
  pa = "va",
  fa = function(self) return "ra" end
}

local ClassB = Class:new {
  pb = "vb",
  fb = function(self) return "rb" end
}

-- #2. Multiple inheritance:
local ClassAB = Class:new {
  pb = "x",
}
ClassAB:mixin(ClassA, ClassB)

assert(Class == getmetatable(ClassAB))
assert(ClassAB.pa == "va")
assert(ClassAB.fa() == "ra")
assert(ClassAB.fb() == "rb")
assert(ClassAB.pb == "x")

assert(ClassAB:hasProperty("pa"))
assert(ClassAB:hasProperty("fa"))
assert(not ClassAB:hasProperty("nonexistent_property"))

-- #3. Create instances:
local instance = ClassAB:new {}
assert(ClassAB == getmetatable(instance))
assert(instance.pa == "va")
assert(instance.fa() == "ra")
assert(instance.fb() == "rb")
assert(instance.pb == "x")

-- #4. Method overriding:
local ClassC = Class:new {
  pc = "vc",
  fc = function(self)
    return "rc from ClassC"
  end
}

-- ClassD inherits from ClassC and overrides fc,
-- calling the superclass implementation via super:
local ClassD = ClassC:new {}

function ClassD:fc()
  return self:super(ClassC, "fc") .. " and extended in ClassD"
end

local instanceD = ClassD:new {}
assert(instanceD:fc() == "rc from ClassC and extended in ClassD")
