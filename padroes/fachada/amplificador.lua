-- amplificador.lua

-- `local` evita vazar a classe como variável global ao ser requerida.
local Amplificador = {}

function Amplificador:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function Amplificador:ligar()
  self.ligado = true
  print("Amplificador está ligado.")
end

function Amplificador:definirVolume(nivel)
  self.volume = nivel
  print("Volume do amplificador definido para " .. nivel)
end

function Amplificador:desligar()
  self.ligado = false
  print("Amplificador está desligado.")
end

return Amplificador
