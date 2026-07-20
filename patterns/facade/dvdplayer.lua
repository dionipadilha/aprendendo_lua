DVDPlayer = {}

function DVDPlayer:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function DVDPlayer:on()
  print("DVD Player is on.")
end

function DVDPlayer:play(movie)
  print("Playing movie: " .. movie)
end

function DVDPlayer:off()
  print("DVD Player is off.")
end

return DVDPlayer
