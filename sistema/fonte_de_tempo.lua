-- fonte_de_tempo.lua

-- Define uma interface de fonte de tempo:
local FonteDeTempo = {
  agora = function(self) error("\nO método deve ser sobrescrito.") end
}

-- Define um construtor da fonte de tempo:
function FonteDeTempo:novo(objeto)
  objeto = objeto or {}
  setmetatable(objeto, self)
  self.__index = self
  return objeto
end

-- Implementação de FonteDeTempo #1: relógio do sistema.
-- os.time devolve a época (epoch) em segundos — a hora atual de verdade.
-- (os.clock NÃO serviria aqui: mede tempo de CPU, não a hora do dia.)
local relogioDoSistema = FonteDeTempo:novo {
  agora = function(self) return os.time() end
}

-- Implementação de FonteDeTempo #2: simulação de sincronização via NTP.
-- Um cliente NTP real consultaria um servidor de hora na rede; a simulação
-- devolve a época atual (os.time), como faria um relógio recém-sincronizado.
local function simularSincronizacaoNtp()
  return os.time()
end

local fonteNtp = FonteDeTempo:novo {
  agora = function(self) return simularSincronizacaoNtp() end
}

-- Usa diferentes implementações de fonte de tempo:
local fontesDeTempo = { relogioDoSistema, fonteNtp }
for _, fonteDeTempo in ipairs(fontesDeTempo) do
  local instante = fonteDeTempo:agora()
  print("Hora atual (época): ", instante, os.date("%d/%m/%Y %X", instante))
  -- Propriedades: época em segundos inteiros, próxima do relógio do sistema:
  assert(math.type(instante) == "integer")
  assert(math.abs(os.difftime(os.time(), instante)) <= 1)
end
