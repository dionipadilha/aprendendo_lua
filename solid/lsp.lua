-- lsp.lua

-- Liskov Substitution Principle:
-- Objects of a derived class should be substitutable for objects of the base

-- #1. Base class

Rectangle = {
  width = 1,
  height = 1
}

function Rectangle:new(rect)
  self.__index = self
  rect = rect or {}
  setmetatable(rect, self)
  return rect
end

function Rectangle:area()
  return self.width * self.height
end

-- #2. Derived class Square
Square = Rectangle:new {
  side = 1
}

function Square:new(sq)
  self.__index = self
  self.width = sq.side or 1
  self.height = sq.side or 1
  sq = sq or {}
  setmetatable(sq, self)
  return sq
end

-- #3. Testing the Liskov Substitution Principle

local function area(shape)
  return shape:area()
end

-- Testing base class Rectangle
assert(area(Rectangle:new {}) == 1)
assert(area(Rectangle:new { width = 4, height = 5 }) == 20)

-- Testing derived class Square
assert(area(Square:new {}) == 1)
assert(area(Square:new { side = 4 }) == 16)

print("All tests passed!")
