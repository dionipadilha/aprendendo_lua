-- heranca_multipla.lua

-- #1. classe abstrata:
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

-- #2. Definir múltiplas classes:
local ClasseA = Classe:novo {
  pa = "va",
  fa = function(self) return "ra" end
}

local ClasseB = Classe:novo {
  pb = "vb",
  fb = function(self) return "rb" end
}

-- #3. Herança múltipla
local ClasseAB = Classe:novo {
  pb = "x",
}
ClasseAB:mixin(ClasseA, ClasseB)

-- #4. Testes
assert(Classe == getmetatable(ClasseAB))
assert(ClasseAB.pa == "va")
assert(ClasseAB.fa() == "ra")
assert(ClasseAB.fb() == "rb")
assert(ClasseAB.pb == "x")

local instancia = ClasseAB:novo {}
assert(ClasseAB == getmetatable(instancia))
assert(instancia.pa == "va")
assert(instancia.fa() == "ra")
assert(instancia.fb() == "rb")
assert(instancia.pb == "x")
