--------------------------------------------------------------------------------
-- suite_de_testes.lua

local TesteUnitarioBasico = require "teste_unitario_basico"
local esperaOcupada = require "espera"

--------------------------------------------------------------------------------
-- simulação de processamento (espera fixa e curta, para uma suíte rápida
-- e determinística)

local duracaoDaSimulacao = 0.1 -- segundos de CPU por caso

local function facaIsso(n)
  esperaOcupada(duracaoDaSimulacao) -- processando
  return n + 1
end

local function facaAquilo(w)
  esperaOcupada(duracaoDaSimulacao) -- processando
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

-- O caso "gatosx" é uma FALHA DEMONSTRATIVA proposital: mostra como o
-- framework reporta uma reprovação sem derrubar a suíte inteira.
SuiteDeTestes.testes_facaAquilo = TesteUnitarioBasico:novo {
  id = "Teste #2 - facaAquilo",
  teste = facaAquilo,
  casos = {
    { entrada = "pato",  esperado = "patos" },
    { entrada = "gato",  esperado = "gatosx" }, -- reprovação demonstrativa
    { entrada = "porco", esperado = "porcos" }
  }
}

function SuiteDeTestes:executar()
  local aprovados1, reprovados1 = self.testes_facaIsso:tentar()
  local aprovados2, reprovados2 = self.testes_facaAquilo:tentar()
  return aprovados1, reprovados1, aprovados2, reprovados2
end

--------------------------------------------------------------------------------
-- Expectativa explícita sobre os totais (asserts DE TOPO):
-- a falha demonstrativa continua didática, mas QUALQUER desvio dos totais
-- abaixo faz a suíte sair com código diferente de zero.

local aprovados1, reprovados1, aprovados2, reprovados2 = SuiteDeTestes:executar()

assert(aprovados1 == 3 and reprovados1 == 0,
  ("lote 1: esperava 3/0, obteve %d/%d"):format(aprovados1, reprovados1))
assert(aprovados2 == 2 and reprovados2 == 1,
  ("lote 2: esperava 2 aprovados e exatamente 1 reprovação demonstrativa, obteve %d/%d")
  :format(aprovados2, reprovados2))

print("\nSuíte concluída: totais conferem com a expectativa declarada.")
--------------------------------------------------------------------------------
