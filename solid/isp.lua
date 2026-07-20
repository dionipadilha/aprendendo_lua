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
    for k, v in pairs(classe) do
      -- Armadilha do mixin ingênuo: se a classe misturada já tiver sido
      -- usada como base, ela carrega um __index — copiá-lo sequestraria
      -- a cadeia de herança do alvo. Pulamos os metacampos.
      if k ~= "__index" then self[k] = v end
    end
  end
end

--------------------------------------------------------------------------------
-- A VIOLAÇÃO: uma interface "gorda" com tudo junto. Quem não come é
-- forçado a implementar comer() de alguma forma — em geral, um erro em
-- tempo de execução à espera de acontecer.

local TrabalhadorCompleto = Classe:novo {
  trabalhar = function(self) return "trabalhando" end,
  comer = function(self) return "comendo" end
}

local RoboForcado = TrabalhadorCompleto:novo {
  -- a interface obriga; o robô só pode "implementar" falhando:
  comer = function(self) error("robôs não comem") end
}

local roboForcado = RoboForcado:novo {}
assert(roboForcado:trabalhar() == "trabalhando")
-- o método existe (a interface gorda obrigou), mas é uma armadilha:
local okComer = pcall(function() return roboForcado:comer() end)
assert(not okComer, "comer() no robô é um erro à espera de acontecer")

--------------------------------------------------------------------------------
-- O REDESENHO em conformidade: interfaces pequenas e segregadas, que
-- cada cliente combina por mixin conforme o que realmente usa.

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
