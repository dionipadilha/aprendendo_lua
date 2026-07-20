--------------------------------------------------------------------------------
-- Implementação de um Cronômetro:

local ICronometro = {}

function ICronometro:novo(contrato)
  contrato = contrato or {}
  setmetatable(contrato, self)
  self.__index = self
  return contrato
end

function ICronometro:iniciar() error("Implementação pela classe concreta") end

function ICronometro:parar() error("Implementação pela classe concreta") end

function ICronometro:registrar() error("Implementação pela classe concreta") end

function ICronometro:zerar() error("Implementação pela classe concreta") end

--------------------------------------------------------------------------------
-- Implementação concreta do Cronometro
local Cronometro = ICronometro:novo { tempoInicial = 0, tempoFinal = 0, executando = false }

function Cronometro:iniciar()
  self.executando = true
  self.tempoInicial = os.clock()
end

function Cronometro:parar()
  self.tempoFinal = os.clock()
  self.executando = false
end

function Cronometro:registrar()
  local tempoDecorrido = 0
  if self.executando then
    tempoDecorrido = os.clock() - self.tempoInicial
    return "Cronômetro em execução. Tempo decorrido: " .. tempoDecorrido .. " segundos."
  else
    tempoDecorrido = self.tempoFinal - self.tempoInicial
    return "Cronômetro parado. Tempo decorrido: " .. tempoDecorrido .. " segundos."
  end
end

function Cronometro:zerar()
  self.tempoInicial = 0
  self.tempoFinal = 0
  self.executando = false
end

--------------------------------------------------------------------------------
-- Teste do Cronômetro:

-- Define uma função de espera para simular uma tarefa demorada
local function esperaOcupada(segundos)
  assert(type(segundos) == "number" and segundos > 0, "A duração da espera deve ser positiva.")
  local tempo_inicial = os.clock()
  while os.clock() - tempo_inicial < segundos do
    -- espera ocupada (busy wait)
  end
end

-- Uso com injeção de dependência
local function teste(cronometro)
  cronometro:iniciar()

  -- Executa algumas operações cronometradas
  print("#1 ...")
  esperaOcupada(1)
  print("#2 ...")
  esperaOcupada(1)
  print(cronometro:registrar()) --> Cronômetro em execução. Tempo decorrido: x segundos.
  print("#3 ...")
  esperaOcupada(1)
  cronometro:parar()

  -- Registra os resultados do cronômetro
  print(cronometro:registrar()) --> Cronômetro parado. Tempo decorrido: y segundos.

  -- Zera o cronômetro
  cronometro:zerar()

  -- Registra os resultados do cronômetro
  assert(cronometro:registrar() == "Cronômetro parado. Tempo decorrido: 0 segundos.")
end

-- Uso
local meuCronometro = Cronometro:novo()
teste(meuCronometro)

--------------------------------------------------------------------------------
