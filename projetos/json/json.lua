-- execute de dentro do diretório json/: lua principal.lua
local jsonDecodificar = require "json_decodificar"
local jsonCodificar = require "json_codificar"

local JSON = {}

function JSON:decodificar(valor)
  return jsonDecodificar(valor)
end

function JSON:codificar(valor)
  return jsonCodificar(valor)
end

return JSON
