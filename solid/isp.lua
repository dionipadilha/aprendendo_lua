-- isp.lua

-- Princípio da Segregação de Interface:
-- Clientes não devem ser forçados a depender de métodos que não usam.

-- Classe Abstrata:
local Classe = {}

function Classe:novo(instancia)
  self.__index = self
  instancia = instancia or {}
  return setmetatable(instancia, self)
end

function Classe:mixin(...)
  local classes = { ... }
  for _, classe in ipairs(classes) do
    for k, v in pairs(classe) do self[k] = v end
  end
end

-- Interfaces:
local Trabalhador = Classe:novo {
  trabalhar = function(self) return "trabalhando" end
}

local Comedor = Classe:novo {
  comer = function(self) return "comendo" end
}

-- Clientes:
local Robo = Trabalhador:novo {
  id = "0000",
  modelo = "indefinido"
}

local Humano = Trabalhador:novo {
  nome = "nome",
  idade = 0
}
Humano:mixin(Comedor)

-- Testes:
local humano = Humano:novo { nome = "João", idade = 30 }
assert(humano:trabalhar() == "trabalhando", "Humano deveria estar trabalhando")
assert(humano:comer() == "comendo", "Humano deveria estar comendo")

local robo = Robo:novo { id = "1234", modelo = "T-800" }
assert(robo:trabalhar() == "trabalhando", "Robô deveria estar trabalhando")
assert(robo.comer == nil, "Robô não deveria ter o método comer")
