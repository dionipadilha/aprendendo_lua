Amplificador = {}

function Amplificador:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function Amplificador:ligar()
  print("Amplificador está ligado.")
end

function Amplificador:definirVolume(nivel)
  print("Volume do amplificador definido para " .. nivel)
end

function Amplificador:desligar()
  print("Amplificador está desligado.")
end

return Amplificador
