-- Classe HomeTheater: a FACHADA que esconde a orquestração dos
-- subsistemas (luzes, projetor, amplificador, leitor de DVD) atrás de
-- duas operações simples.
-- `local` evita vazar a classe como variável global ao ser requerida.
local HomeTheater = {}

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
  self.leitorDvd:ligar()
  self.leitorDvd:reproduzir(filme)
end

function HomeTheater:encerrarFilme()
  print("Desligando o cinema em casa...")
  self.luzes:desligar()
  self.projetor:desligar()
  self.amplificador:desligar()
  self.leitorDvd:desligar()
end

return HomeTheater
