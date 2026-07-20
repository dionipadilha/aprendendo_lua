local Class = {}

function Class:new(object)
  self.__index = self
  object = object or {}
  setmetatable(object, self)
  return object
end

return Class
