LuzesDoCinema = {}

function LuzesDoCinema:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function LuzesDoCinema:atenuar(nivel)
  print("Luzes do cinema atenuadas para " .. nivel .. "%")
end

function LuzesDoCinema:desligar()
  print("Luzes do cinema estão apagadas.")
end

return LuzesDoCinema
