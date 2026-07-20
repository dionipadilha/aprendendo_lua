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
print(co)                   --> id da thread
print(coroutine.status(co)) --> suspended

-- retoma a corrotina até que ela termine:
repeat
  local sucesso, resposta = coroutine.resume(co)
  if not sucesso then
    print("Erro:", resposta)
    break
  end
  print(sucesso, resposta)
until coroutine.status(co) == "dead"
