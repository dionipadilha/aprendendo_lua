Projetor = {}

function Projetor:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function Projetor:ligar()
  print("Projetor está ligado.")
end

function Projetor:desligar()
  print("Projetor está desligado.")
end

return Projetor
