-- HomeTheater class
HomeTheater = {}

function HomeTheater:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function HomeTheater:watchMovie(movie)
  print("Get ready to watch a movie...")
  self.lights:dim(10)
  self.projector:on()
  self.amplifier:on()
  self.amplifier:setVolume(5)
  self.dvdplayer:on()
  self.dvdplayer:play(movie)
end

function HomeTheater:endMovie()
  print("Shutting movie theater down...")
  self.lights:off()
  self.projector:off()
  self.amplifier:off()
  self.dvdplayer:off()
end

return HomeTheater
