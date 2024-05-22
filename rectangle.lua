-- rectangle.lua

--------------------------------------------------------------------------------
-- Rectangle class:

local Rectangle = {}

-- Constructor:
function Rectangle:new(bottomLeftCorner, topRightCorner)
  -- Create new rectangle object:
  local rect = {}
  setmetatable(rect, self)
  self.__index = self

  -- Set default values:
  bottomLeftCorner = bottomLeftCorner or { 0, 0 }
  topRightCorner = topRightCorner or { 0, 0 }

  -- Extract coordinates from the object:
  rect.x1, rect.y1 = bottomLeftCorner[1], bottomLeftCorner[2]
  rect.x2, rect.y2 = topRightCorner[1], topRightCorner[2]

  -- Calculate dimensions:
  rect.width = math.abs(rect.x2 - rect.x1)
  rect.height = math.abs(rect.y2 - rect.y1)

  return rect
end

-- String Representation:
function Rectangle:__tostring()
  local log = "Rectangle({%d, %d}, {%d, %d})"
  return log:format(self.x1, self.y1, self.x2, self.y2)
end

--------------------------------------------------------------------------------
-- Rectangle methods:

-- Calculate the area:
function Rectangle:area()
  return self.width * self.height
end

-- Calculate the Centroid:
function Rectangle:regionCentroid()
  local x = (self.x1 + self.x2) / 2
  local y = (self.y1 + self.y2) / 2
  return { x, y }
end

-- Calculate the perimeter:
function Rectangle:perimeter()
  return 2 * (self.width + self.height)
end

--------------------------------------------------------------------------------
-- Example usage:

local rect = Rectangle:new({ 0, 0 }, { 1, 3 })
print(rect)                                --> Rectangle({0, 0}, {1, 3})
print(rect:area())                         --> 3
print(table.unpack(rect:regionCentroid())) --> 0.5 1.5
print(rect:perimeter())                    --> 8

--------------------------------------------------------------------------------
-- Return the Rectangle class:

return Rectangle

--------------------------------------------------------------------------------
