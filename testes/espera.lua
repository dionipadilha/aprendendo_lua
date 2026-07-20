-- espera.lua
-- Módulo de espera OCUPADA (busy-wait de CPU), usado pela suíte para
-- simular processamento. Usa os.clock porque o laço consome CPU.

local function esperaOcupada(n)
  -- mesma validação de ../sistema/espera.lua: mensagem clara em vez de
  -- um erro de comparação ao receber um tipo errado
  assert(type(n) == "number" and n > 0, "a duração deve ser um número positivo")
  local tempoInicial = os.clock()
  while os.clock() - tempoInicial < n do
    -- nada
  end
end

return esperaOcupada
