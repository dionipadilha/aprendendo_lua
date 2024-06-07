local DVDPlayer   = require "dvdplayer"
local Projector   = require "projector"
local Amplifier   = require "amplifier"
local Lights      = require "lights"
local HomeTheater = require "hometheater"

local dvdplayer   = DVDPlayer:new()
local projector   = Projector:new()
local amplifier   = Amplifier:new()
local lights      = Lights:new()

local homeTheater = HomeTheater:new {
  dvdplayer = dvdplayer,
  projector = projector,
  amplifier = amplifier,
  lights = lights
}

local function main()
  print(homeTheater.dvdplayer:on())
  homeTheater:watchMovie("Inception")
  print("Watching ...")
  homeTheater:endMovie()
end

main()
