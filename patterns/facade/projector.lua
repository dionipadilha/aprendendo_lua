Projector = {}

function Projector:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function Projector:on()
  print("Projector is on.")
end

function Projector:off()
  print("Projector is off.")
end

return Projector
