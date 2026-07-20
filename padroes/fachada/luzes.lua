-- luzes.lua

-- `local` evita vazar a classe como variável global ao ser requerida.
local LuzesDoCinema = {}

function LuzesDoCinema:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function LuzesDoCinema:atenuar(nivel)
  self.nivel = nivel
  print("Luzes do cinema atenuadas para " .. nivel .. "%")
end

function LuzesDoCinema:desligar()
  self.nivel = 0
  print("Luzes do cinema estão apagadas.")
end

return LuzesDoCinema
