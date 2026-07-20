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

-- Implementação de FonteDeTempo #1: os.clock
local fonteDeTempo1 = FonteDeTempo:novo {
  agora = function(self) return os.clock() end
}

-- Implementação de FonteDeTempo #2: simulação de ntp
local function simularSincronizacaoNtp()
  return os.clock()
end

local fonteDeTempo2 = FonteDeTempo:novo {
  agora = function(self) return simularSincronizacaoNtp() end
}

-- Usa diferentes implementações de fonte de tempo:
local fontesDeTempo = { fonteDeTempo1, fonteDeTempo2 }
for _, fonteDeTempo in ipairs(fontesDeTempo) do
  print("Hora atual: ", fonteDeTempo:agora())
end
