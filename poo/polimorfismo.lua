-- polimorfismo.lua

-- classes diferentes respondem de forma diferente à mesma chamada de função

--------------------------------------------------------------------------------
-- Classe base dos animais:

local Animal = {
  nomeDaClasse = "animal"
}

function Animal:novo(instancia)
  instancia = instancia or {}
  setmetatable(instancia, self)
  self.__index = self
  return instancia
end

function Animal:andar()
  return true, string.format("Este %s pode andar", self.nomeDaClasse)
end

--------------------------------------------------------------------------------
-- Subclasses de Animal:

local Passaro = Animal:novo {
  nomeDaClasse = "pássaro"
}

function Passaro:voar()
  return true, "Este pássaro pode voar"
end

--------------------------------------------------------------------------------
-- Subclasses de Passaro:

-- Classe Pardal:
local Pardal = Passaro:novo {}

-- Classe Pinguim:
local Pinguim = Passaro:novo {}
function Pinguim:voar()
  return false, "Pinguins não podem voar"
end

--------------------------------------------------------------------------------
-- Fazer um pássaro andar:

print(Pardal:andar())  --> true	Este pássaro pode andar
print(Pinguim:andar()) --> true	Este pássaro pode andar

local pode, mensagem = Pardal:andar()
assert(pode == true and mensagem == "Este pássaro pode andar")
pode, mensagem = Pinguim:andar()
assert(pode == true and mensagem == "Este pássaro pode andar")

--------------------------------------------------------------------------------
-- Fazer um pássaro voar: cada classe responde à sua maneira (polimorfismo).

print(Pardal:voar())  --> true	Este pássaro pode voar
print(Pinguim:voar()) --> false	Pinguins não podem voar

pode, mensagem = Pardal:voar()
assert(pode == true and mensagem == "Este pássaro pode voar")
pode, mensagem = Pinguim:voar()
assert(pode == false and mensagem == "Pinguins não podem voar")

--------------------------------------------------------------------------------
