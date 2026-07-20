-- comum.lua

local Classe = {}

function Classe:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  setmetatable(objeto, self)
  return objeto
end

return Classe
