-- leitor_dvd.lua

-- `local` evita vazar a classe como variável global ao ser requerida.
local LeitorDVD = {}

function LeitorDVD:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function LeitorDVD:ligar()
  self.ligado = true
  print("Leitor de DVD está ligado.")
end

function LeitorDVD:reproduzir(filme)
  self.filme = filme
  print("Reproduzindo filme: " .. filme)
end

function LeitorDVD:desligar()
  self.ligado = false
  print("Leitor de DVD está desligado.")
end

return LeitorDVD
