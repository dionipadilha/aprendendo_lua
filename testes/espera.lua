local function esperaOcupada(n)
  assert(n > 0)
  local tempoInicial = os.clock()
  while os.clock() - tempoInicial < n do
    -- nada
  end
end

return esperaOcupada
