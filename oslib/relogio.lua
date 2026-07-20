-- os.clock
local function espera(intervalo)
  local fim = os.clock() + intervalo
  while os.clock() < fim do end
end

local inicio = os.clock()
espera(5)            -- segundos
local fim = os.clock()
print(fim - inicio) --> 5.000003
