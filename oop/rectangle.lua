-- rectangle.lua

--------------------------------------------------------------------------------
-- Rectangle class:

local Rectangle = {}

-- Constructor:
function Rectangle:new(bottomLeftCorner, topRightCorner)
  -- Validate input:
  assert(
    type(bottomLeftCorner) == "table" and #bottomLeftCorner == 2,
    "Invalid bottom-left corner"
  )

  assert(
    type(topRightCorner) == "table" and #topRightCorner == 2,
    "Invalid top-right corner"
  )

  -- Create new rectangle object:
  local rect = {}
  setmetatable(rect, self)
  self.__index = self

  -- Set default corners:
  bottomLeftCorner = bottomLeftCorner or { 0, 0 }
  topRightCorner = topRightCorner or { 0, 0 }

  -- Extract coordinates from the corners:
  rect.x1, rect.y1 = bottomLeftCorner[1], bottomLeftCorner[2]
  rect.x2, rect.y2 = topRightCorner[1], topRightCorner[2]

  -- Calculate dimensions:
  rect.width = math.abs(rect.x2 - rect.x1)
  rect.height = math.abs(rect.y2 - rect.y1)

  return rect
end

-- String Representation:
function Rectangle:__tostring()
  local log = "Rectangle({%f, %f}, {%f, %f})"
  return log:format(self.x1, self.y1, self.x2, self.y2)
end

--------------------------------------------------------------------------------
-- Calculate frequently accessed properties:

-- Calculate the perimeter:
function Rectangle:perimeter()
  return 2 * (self.width + self.height)
end

-- Calculate the area:
function Rectangle:area()
  return self.width * self.height
end

-- Calculate the centroid:
function Rectangle:regionCentroid()
  local x = (self.x1 + self.x2) / 2
  local y = (self.y1 + self.y2) / 2
  return { x, y }
end

-- Check if a point is inside the rectangle:
function Rectangle:contains(point)
  local px, py = point[1], point[2]
  return px >= self.x1 and px <= self.x2 and py >= self.y1 and py <= self.y2
end

-- Check if another rectangle intersects with this rectangle:
function Rectangle:intersects(region)
  return not (
    region.x1 > self.x2
    or region.x2 < self.x1
    or region.y1 > self.y2
    or region.y2 < self.y1
  )
end

-- Scale the rectangle by a given factor:
function Rectangle:scale(factor)
  local cx, cy = table.unpack(self:regionCentroid())
  local halfWidth = (self.width * factor) / 2
  local halfHeight = (self.height * factor) / 2
  local bottomLeftCorner = { cx - halfWidth, cy - halfHeight }
  local topRightCorner = { cx + halfWidth, cy + halfHeight }
  return Rectangle:new(bottomLeftCorner, topRightCorner)
end

-- Move the rectangle by a given delta:
function Rectangle:move(dx, dy)
  local bottomLeftCorner = { self.x1 + dx, self.y1 + dy }
  local topRightCorner = { self.x2 + dx, self.y2 + dy }
  return Rectangle:new(bottomLeftCorner, topRightCorner)
end

-- Resize the rectangle to new dimensions:
function Rectangle:resize(newWidth, newHeight)
  assert(newWidth > 0 and newHeight > 0, "Invalid dimensions")
  local bottomLeftCorner = { self.x1, self.y1 }
  local topRightCorner = { self.x1 + newWidth, self.y1 + newHeight }
  return Rectangle:new(bottomLeftCorner, topRightCorner)
end

--------------------------------------------------------------------------------
-- Example usage:

-- create a rectangle instance:
local rect1 = Rectangle:new({ 0, 0 }, { 1, 3 })
print(rect1) --> Rectangle({0.000000, 0.000000}, {1.000000, 3.000000})

-- get basic geometry:
print(rect1:perimeter()) --> 8
print(rect1:area())      --> 3

-- get rectangle centroid:
local centroid = rect1:regionCentroid()
print(table.unpack(centroid))   --> 0.5 1.5
print(rect1:contains(centroid)) --> true
print(rect1:contains({ 1, 4 })) --> false

-- Check if another rectangle intersects with this rectangle:
local rect2 = Rectangle:new({ 0.5, 0.5 }, { 2, 4 })
print(rect1:intersects(rect2)) --> true

-- get scaled rectangle:
local scaledRect = rect1:scale(2)
print(rect1)      --> Rectangle({0.000000, 0.000000}, {1.000000, 3.000000})
print(scaledRect) --> Rectangle({-0.500000, -1.500000}, {1.500000, 4.500000})

-- move rectangle:
local movedRect = rect1:move(1, 1)
print(movedRect) --> Rectangle({1.000000, 1.000000}, {2.000000, 4.000000})

-- resize rectangle:
local resizedRect = rect1:resize(2, 4)
print(resizedRect) --> Rectangle({0.000000, 0.000000}, {2.000000, 4.000000})

--------------------------------------------------------------------------------
-- Return the Rectangle class:

return Rectangle

--------------------------------------------------------------------------------
