-- ciclo_de_vida_das_corrotinas.lua

--  cria uma função de corrotina:
local function fazAlgo()
  print("fazAlgo #1")
  coroutine.yield("cedendo #1")
  print("fazAlgo #2")
  coroutine.yield("cedendo #2")
  return "corrotina concluída!"
end

--  cria um objeto de corrotina:
local co = coroutine.create(fazAlgo)
print(co)                   --> id da thread (thread: 0x...)
assert(type(co) == "thread")
print(coroutine.status(co)) --> suspended
assert(coroutine.status(co) == "suspended")

-- retoma a corrotina até que ela termine:
local respostas = {}
repeat
  local sucesso, resposta = coroutine.resume(co)
  assert(sucesso, resposta)
  table.insert(respostas, resposta)
  print(sucesso, resposta)
until coroutine.status(co) == "dead"

assert(respostas[1] == "cedendo #1")
assert(respostas[2] == "cedendo #2")
assert(respostas[3] == "corrotina concluída!")
assert(coroutine.status(co) == "dead")

--------------------------------------------------------------------------------
-- coroutine.close (Lua 5.4): encerra uma corrotina suspensa sem retomá-la.

local descartavel = coroutine.create(function()
  coroutine.yield("primeiro valor")
  return "nunca chega aqui"
end)

local sucesso, valor = coroutine.resume(descartavel)
assert(sucesso == true and valor == "primeiro valor")
assert(coroutine.status(descartavel) == "suspended")

-- Decidimos não consumir o restante: close libera a corrotina e ela morre.
local fechou = coroutine.close(descartavel)
assert(fechou == true)
assert(coroutine.status(descartavel) == "dead")
print("corrotina encerrada com coroutine.close") --> corrotina encerrada com coroutine.close
