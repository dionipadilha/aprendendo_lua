-- isp.lua

-- Interface Segregation Principle:
-- Clients shouldn't be forced to depend on methods they don't use.

-- Abstract Class:
local Class = {}

function Class:new(instance)
  self.__index = self
  instance = instance or {}
  return setmetatable(instance, self)
end

function Class:mixin(...)
  local classes = { ... }
  for _, class in ipairs(classes) do
    for k, v in pairs(class) do self[k] = v end
  end
end

-- Interfaces:
local Worker = Class:new {
  work = function(self) return "working" end
}

local Eatable = Class:new {
  eat = function(self) return "eating" end
}

-- Clients:
local Robot = Worker:new {
  id = "0000",
  model = "undefined"
}

local Human = Worker:new {
  name = "name",
  age = 0
}
Human:mixin(Eatable)

-- Testing:
local human = Human:new { name = "John", age = 30 }
assert(human:work() == "working", "Human should be working")
assert(human:eat() == "eating", "Human should be eating")

local robot = Robot:new { id = "1234", model = "T-800" }
assert(robot:work() == "working", "Robot should be working")
assert(robot.eat == nil, "Robot should not have eat method")
