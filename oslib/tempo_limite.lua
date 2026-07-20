-- função definirTempoLimite (setTimeout) para corrotinas de Lua

local function definirTempoLimite(funcaoDeRetorno, segundosDeEspera)
  local tempoInicial = os.clock()
  local function verificarTempo()
      if os.clock() - tempoInicial >= segundosDeEspera then
          funcaoDeRetorno()
          return true
      else
          return false
      end
  end

  repeat
      coroutine.yield()
  until verificarTempo()
end

-- Uso
local corrotina = coroutine.create(function()
  definirTempoLimite(function() print("Olá, Mundo!") end, 1) -- espera de 1 segundo
end)

-- Este laço é necessário para manter a corrotina em execução
while coroutine.status(corrotina) ~= 'dead' do
  coroutine.resume(corrotina)
end
