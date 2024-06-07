TheaterLights = {}

function TheaterLights:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function TheaterLights:dim(level)
  print("Theater lights dimmed to " .. level .. "%")
end

function TheaterLights:off()
  print("Theater lights are off.")
end

return TheaterLights
