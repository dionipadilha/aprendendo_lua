local LeitorDVD    = require "leitor_dvd"
local Projetor     = require "projetor"
local Amplificador = require "amplificador"
local Luzes        = require "luzes"
local HomeTheater  = require "home_theater"

local leitor_dvd   = LeitorDVD:novo()
local projetor     = Projetor:novo()
local amplificador = Amplificador:novo()
local luzes        = Luzes:novo()

local homeTheater = HomeTheater:novo {
  leitor_dvd = leitor_dvd,
  projetor = projetor,
  amplificador = amplificador,
  luzes = luzes
}

local function principal()
  print(homeTheater.leitor_dvd:ligar())
  homeTheater:assistirFilme("A Origem")
  print("Assistindo ...")
  homeTheater:encerrarFilme()
end

principal()
