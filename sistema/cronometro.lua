-- cronometro.lua

--------------------------------------------------------------------------------
-- Um cronômetro mede TEMPO DE PAREDE (tempo real transcorrido), por isso
-- usa os.time e os.difftime. os.clock mede tempo de CPU e fica reservado
-- para benchmarks — veja cpu_vs_parede.lua para a diferença na prática.
-- Atenção: os.time tem resolução de 1 segundo.

-- O require fica AQUI, fora da seção cronometrada do teste: dormir.lua
-- roda um autoteste ao ser carregado (dorme ~1 s), e essa carga não pode
-- contaminar a medição feita lá embaixo.
local dormir = require "dormir"

--------------------------------------------------------------------------------
-- Interface do Cronômetro:

local ICronometro = {}

function ICronometro:novo(contrato)
  contrato = contrato or {}
  setmetatable(contrato, self)
  self.__index = self
  return contrato
end

function ICronometro:iniciar() error("Implementação pela classe concreta") end

function ICronometro:parar() error("Implementação pela classe concreta") end

function ICronometro:decorrido() error("Implementação pela classe concreta") end

function ICronometro:registrar() error("Implementação pela classe concreta") end

function ICronometro:zerar() error("Implementação pela classe concreta") end

--------------------------------------------------------------------------------
-- Implementação concreta do Cronômetro (tempo de parede):

local Cronometro = ICronometro:novo { tempoInicial = 0, tempoFinal = 0, executando = false }

function Cronometro:iniciar()
  self.executando = true
  self.tempoInicial = os.time()
end

function Cronometro:parar()
  self.tempoFinal = os.time()
  self.executando = false
end

-- Retorna o tempo decorrido em segundos (resolução de 1 s, de os.time):
function Cronometro:decorrido()
  if self.executando then
    return os.difftime(os.time(), self.tempoInicial)
  end
  return os.difftime(self.tempoFinal, self.tempoInicial)
end

function Cronometro:registrar()
  local estado = self.executando and "em execução" or "parado"
  return ("Cronômetro %s. Tempo decorrido: %d segundos."):format(estado, self:decorrido())
end

function Cronometro:zerar()
  self.tempoInicial = 0
  self.tempoFinal = 0
  self.executando = false
end

--------------------------------------------------------------------------------
-- Teste do Cronômetro (com injeção de dependência):

local function teste(cronometro)
  cronometro:iniciar()

  -- Espera OCIOSA (a CPU fica livre): um cronômetro de parede conta mesmo assim.
  -- Com os.clock aqui, o tempo medido seria ~0 — essa é a diferença.
  dormir(1)

  print(cronometro:registrar()) --> Cronômetro em execução. Tempo decorrido: 1 segundos. (às vezes 2: resolução de 1 s)
  assert(cronometro.executando)

  cronometro:parar()
  local decorrido = cronometro:decorrido()
  -- Propriedade didática: o cronômetro ENXERGA a espera — dormiu 1 s, logo
  -- decorrido >= 1. O teto (30 s) é generoso de propósito: sob carga, o
  -- sistema pode atrasar o processo além do sono pedido, e uma janela
  -- estreita tornaria o teste intermitente sem ensinar nada sobre o
  -- cronômetro (o que se verifica é "ele mede o tempo", não "a máquina
  -- está sem carga").
  assert(decorrido >= 1 and decorrido <= 30,
    "tempo decorrido fora da faixa esperada: " .. decorrido)
  print(cronometro:registrar()) --> Cronômetro parado. Tempo decorrido: 1 segundos. (às vezes 2: resolução de 1 s)

  -- Zera o cronômetro e confere o estado limpo:
  cronometro:zerar()
  assert(cronometro:registrar() == "Cronômetro parado. Tempo decorrido: 0 segundos.")
end

-- Uso
local meuCronometro = Cronometro:novo()
teste(meuCronometro)

--------------------------------------------------------------------------------
