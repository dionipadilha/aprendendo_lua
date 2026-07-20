-- espera.lua
-- Módulo de espera OCUPADA (busy-wait de CPU), usado pela suíte para
-- simular processamento. Usa os.clock porque o laço consome CPU.

local function esperaOcupada(n)
  assert(n > 0)
  local tempoInicial = os.clock()
  while os.clock() - tempoInicial < n do
    -- nada
  end
end

return esperaOcupada
