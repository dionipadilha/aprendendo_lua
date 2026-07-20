-- principal.lua

local LeitorDVD    = require "leitor_dvd"
local Projetor     = require "projetor"
local Amplificador = require "amplificador"
local Luzes        = require "luzes"
local HomeTheater  = require "home_theater"

local leitorDvd    = LeitorDVD:novo()
local projetor     = Projetor:novo()
local amplificador = Amplificador:novo()
local luzes        = Luzes:novo()

local homeTheater = HomeTheater:novo {
  leitorDvd = leitorDvd,
  projetor = projetor,
  amplificador = amplificador,
  luzes = luzes
}

local function principal()
  homeTheater:assistirFilme("A Origem")

  -- a fachada orquestrou todos os subsistemas com uma única chamada:
  assert(luzes.nivel == 10)
  assert(projetor.ligado == true)
  assert(amplificador.ligado == true and amplificador.volume == 5)
  assert(leitorDvd.ligado == true and leitorDvd.filme == "A Origem")

  print("Assistindo ...")
  homeTheater:encerrarFilme()

  assert(luzes.nivel == 0)
  assert(projetor.ligado == false)
  assert(amplificador.ligado == false)
  assert(leitorDvd.ligado == false)
end

principal()
