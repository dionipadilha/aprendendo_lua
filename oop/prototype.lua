-- prototype.lua

-- #1. Defining a prototype table:
local ParentClass = {}
ParentClass.parent_key = "parent_value"

-- #2. Creating a factory method:
function ParentClass:new(object)
  object = object or {}
  self.__index = self
  return setmetatable(object, self)
end

-- #3. Creating a child class:
local ChildClass = ParentClass:new()
ChildClass.child_key = "child_value"

-- #4. Creating an object instance:
local object = ChildClass:new()
object.self_key = "self_value"

-- #5. Access properties at different levels:
print(object.parent_key) --> parent_value
print(object.child_key)  --> child_value
print(object.self_key)   --> self_value
