-- espera.lua

-- Define uma função:
local function espera(n)
  assert(n > 0)
  local tempo_inicial = os.clock()
  while os.clock() - tempo_inicial < n do
    -- nada
  end
end
