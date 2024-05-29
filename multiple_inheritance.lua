-- multiple_inheritance.lua

-- #1. abstracat class:
local Class = {}

function Class:new(instace)
  self.__index = self
  instace = instace or {}
  return setmetatable(instace, self)
end

function Class:mixin(...)
  local classes = { ... }
  for _, class in ipairs(classes) do
    for k, v in pairs(class) do
      if not self[k] then self[k] = v end
    end
  end
end

-- #2. Define multiple classes:
local ClassA = Class:new {
  pa = "va",
  fa = function(self) return "ra" end
}

local ClassB = Class:new {
  pb = "vb",
  fb = function(self) return "rb" end
}

-- #3. Multiple inheritance
local ClassAB = Class:new {
  pb = "x",
}
ClassAB:mixin(ClassA, ClassB)

-- #4. Testing
assert(ClassAB.pa == "va")
assert(ClassAB.fa() == "ra")
assert(ClassAB.fb() == "rb")
assert(ClassAB.pb == "x")
