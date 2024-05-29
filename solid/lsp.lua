-- lsp.lua

-- Liskov Substitution Principle:
-- Objects of a derived class should be substitutable for objects of the base.

local Shape = {}

function Shape:new(shape)
  shape = shape or {}
  setmetatable(shape, self)
  self.__index = self
  return shape
end

function Shape:area()
  error("This method should be overridden")
end

local Rectangle = Shape:new()

function Rectangle:new(length, width)
  local rectangle = Shape.new(self)
  rectangle.length = length or 1
  rectangle.width = width or 1
  return rectangle
end

function Rectangle:area()
  return self.length * self.width
end

local Square = Rectangle:new()

function Square:new(side)
  local square = Rectangle.new(self, side, side)
  return square
end

-- Test
local shapes = {
  Rectangle:new(3, 4), --> 12
  Square:new(5)        --> 25
}

for _, shape in ipairs(shapes) do
  print(shape:area())
end
