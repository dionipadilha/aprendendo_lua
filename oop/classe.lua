-- classe.lua

-- classe abstrata:
local Classe = {}

function Classe:novo(instancia)
  self.__index = self
  instancia = instancia or {}
  return setmetatable(instancia, self)
end

function Classe:mixin(...)
  local classes = { ... }
  for _, classe in ipairs(classes) do
    for k, v in pairs(classe) do
      if not self[k] then self[k] = v end
    end
  end
end

function Classe:temPropriedade(nomeDaPropriedade)
  return self[nomeDaPropriedade]
end

function Classe:super(classe, nomeDoMetodo, ...)
  if classe and classe[nomeDoMetodo] then
    return classe[nomeDoMetodo](self, ...)
  else
    error("Método da superclasse não encontrado: " .. tostring(nomeDoMetodo))
  end
end

-- Testes

-- #1. Definir múltiplas classes:
local ClasseA = Classe:novo {
  pa = "va",
  fa = function(self) return "ra" end
}

local ClasseB = Classe:novo {
  pb = "vb",
  fb = function(self) return "rb" end
}

-- #2. Herança múltipla:
local ClasseAB = Classe:novo {
  pb = "x",
}
ClasseAB:mixin(ClasseA, ClasseB)

assert(Classe == getmetatable(ClasseAB))
assert(ClasseAB.pa == "va")
assert(ClasseAB.fa() == "ra")
assert(ClasseAB.fb() == "rb")
assert(ClasseAB.pb == "x")

assert(ClasseAB:temPropriedade("pa"))
assert(ClasseAB:temPropriedade("fa"))
assert(not ClasseAB:temPropriedade("propriedade_inexistente"))

-- #3. Criar instâncias:
local instancia = ClasseAB:novo {}
assert(ClasseAB == getmetatable(instancia))
assert(instancia.pa == "va")
assert(instancia.fa() == "ra")
assert(instancia.fb() == "rb")
assert(instancia.pb == "x")

-- #4. Sobrescrita de método:
local ClasseC = Classe:novo {
  pc = "vc",
  fc = function(self)
    return "rc da ClasseC"
  end
}

-- ClasseD herda de ClasseC e sobrescreve fc,
-- chamando a implementação da superclasse via super:
local ClasseD = ClasseC:novo {}

function ClasseD:fc()
  return self:super(ClasseC, "fc") .. " e estendido na ClasseD"
end

local instanciaD = ClasseD:novo {}
assert(instanciaD:fc() == "rc da ClasseC e estendido na ClasseD")
