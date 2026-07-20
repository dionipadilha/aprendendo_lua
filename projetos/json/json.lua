-- execute de dentro do diretório json/: lua principal.lua
local json_decodificar = require "json_decodificar"
local json_codificar = require "json_codificar"

local JSON = {}

function JSON:decodificar(valor)
  return json_decodificar(valor)
end

function JSON:codificar(valor)
  return json_codificar(valor)
end

return JSON
