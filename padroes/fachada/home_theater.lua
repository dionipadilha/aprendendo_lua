-- Classe HomeTheater
HomeTheater = {}

function HomeTheater:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

function HomeTheater:assistirFilme(filme)
  print("Prepare-se para assistir a um filme...")
  self.luzes:atenuar(10)
  self.projetor:ligar()
  self.amplificador:ligar()
  self.amplificador:definirVolume(5)
  self.leitor_dvd:ligar()
  self.leitor_dvd:reproduzir(filme)
end

function HomeTheater:encerrarFilme()
  print("Desligando o cinema em casa...")
  self.luzes:desligar()
  self.projetor:desligar()
  self.amplificador:desligar()
  self.leitor_dvd:desligar()
end

return HomeTheater
