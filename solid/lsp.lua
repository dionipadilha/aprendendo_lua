-- lsp.lua

-- Princípio da Substituição de Liskov:
-- Objetos de uma classe derivada devem poder substituir objetos da base.

local Forma = {}

function Forma:novo(forma)
  forma = forma or {}
  setmetatable(forma, self)
  self.__index = self
  return forma
end

function Forma:area()
  error("Este método deve ser sobrescrito")
end

local Retangulo = Forma:novo()

function Retangulo:novo(comprimento, largura)
  local retangulo = Forma.novo(self)
  retangulo.comprimento = comprimento or 1
  retangulo.largura = largura or 1
  return retangulo
end

function Retangulo:area()
  return self.comprimento * self.largura
end

local Quadrado = Retangulo:novo()

function Quadrado:novo(lado)
  local quadrado = Retangulo.novo(self, lado, lado)
  return quadrado
end

-- Teste
local formas = {
  Retangulo:novo(3, 4), --> 12
  Quadrado:novo(5)      --> 25
}

for _, forma in ipairs(formas) do
  print(forma:area())
end
