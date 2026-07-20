-- tempo_limite.lua

-- função definirTempoLimite (setTimeout) para corrotinas de Lua.
-- O laço de retomada abaixo é um busy-wait: ocupa a CPU enquanto espera,
-- por isso os.clock (tempo de CPU) funciona como medida aqui. Para esperas
-- ociosas, use os.time — veja cpu_vs_parede.lua.

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
local disparou = false
local corrotina = coroutine.create(function()
  definirTempoLimite(function()
    disparou = true
    print("Olá, Mundo!")
  end, 0.2) -- espera curta de 0.2 segundo
end)

-- Este laço é necessário para manter a corrotina em execução
while coroutine.status(corrotina) ~= 'dead' do
  coroutine.resume(corrotina)
end

assert(disparou, "a função de retorno deveria ter sido chamada após o tempo limite")
