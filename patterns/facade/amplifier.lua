Amplifier = {}

function Amplifier:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function Amplifier:on()
  print("Amplifier is on.")
end

function Amplifier:setVolume(level)
  print("Amplifier volume set to " .. level)
end

function Amplifier:off()
  print("Amplifier is off.")
end

return Amplifier
