-- `local` evita vazar a classe como variável global ao ser requerida.
local Projetor = {}

function Projetor:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function Projetor:ligar()
  self.ligado = true
  print("Projetor está ligado.")
end

function Projetor:desligar()
  self.ligado = false
  print("Projetor está desligado.")
end

return Projetor
