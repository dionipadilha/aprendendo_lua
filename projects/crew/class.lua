local Class = {}

function Class:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

return Class