-- sobrescrita.lua

-- #1. Classe abstrata:
local Classe = {}

function Classe:novo(instancia)
  self.__index = self
  instancia = instancia or {}
  return setmetatable(instancia, self)
end

function Classe:super(classe, nomeDoMetodo, ...)
  if classe and classe[nomeDoMetodo] then
    return classe[nomeDoMetodo](self, ...)
  else
    error("Método da superclasse não encontrado: " .. tostring(nomeDoMetodo))
  end
end

-- #2. Definir a ClasseA com um método saudar:
local ClasseA = Classe:novo {
  saudar = function(self)
    return "Olá da ClasseA"
  end
}

-- #3. Definir a ClasseB, que herda de ClasseA e sobrescreve o método saudar
local ClasseB = ClasseA:novo {}

function ClasseB:saudar()
  return self:super(ClasseA, "saudar") .. " e boas-vindas da ClasseB"
end

-- #4. Testes
local instanciaA = ClasseA:novo {}
print(instanciaA:saudar()) --> Olá da ClasseA

local instanciaB = ClasseB:novo {}
print(instanciaB:saudar()) --> Olá da ClasseA e boas-vindas da ClasseB
