LeitorDVD = {}

function LeitorDVD:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function LeitorDVD:ligar()
  print("Leitor de DVD está ligado.")
end

function LeitorDVD:reproduzir(filme)
  print("Reproduzindo filme: " .. filme)
end

function LeitorDVD:desligar()
  print("Leitor de DVD está desligado.")
end

return LeitorDVD
