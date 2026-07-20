--------------------------------------------------------------------------------
-- suite_de_testes.lua

local TesteUnitarioBasico = require "teste_unitario_basico"
local esperaOcupada = require "espera"

--------------------------------------------------------------------------------
-- simulação de processamento

local function facaIsso(n)
  esperaOcupada(math.random(3)) -- processando
  return n + 1
end

local function facaAquilo(w)
  esperaOcupada(math.random(3)) -- processando
  return w .. "s"
end

--------------------------------------------------------------------------------
local SuiteDeTestes = {}

SuiteDeTestes.testes_facaIsso = TesteUnitarioBasico:novo {
  id = "Teste #1 - facaIsso",
  teste = facaIsso,
  casos = {
    { entrada = 1, esperado = 2 },
    { entrada = 3, esperado = 4 },
    { entrada = 5, esperado = 6 }
  }
}

SuiteDeTestes.testes_facaAquilo = TesteUnitarioBasico:novo {
  id = "Teste #2 - facaAquilo",
  teste = facaAquilo,
  casos = {
    { entrada = "pato",  esperado = "patos" },
    { entrada = "gato",  esperado = "gatosx" },
    { entrada = "porco", esperado = "porcos" }
  }
}

function SuiteDeTestes:executar()
  self.testes_facaIsso:tentar()
  self.testes_facaAquilo:tentar()
end

SuiteDeTestes:executar()
--------------------------------------------------------------------------------
