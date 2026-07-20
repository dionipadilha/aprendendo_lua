-- cria uma função de corrotina usando coroutine.wrap():
local fazAlgo = coroutine.wrap(function()
  print("fazAlgo #1")
  coroutine.yield("cedendo #1")
  print("fazAlgo #2")
  coroutine.yield("cedendo #2")
  return "corrotina concluída!"
end)


-- retoma a corrotina encapsulada:
local resposta = fazAlgo() --> fazAlgo #1
print(resposta)            --> cedendo #1
resposta = fazAlgo()       --> fazAlgo #2
print(resposta)            --> cedendo #2
resposta = fazAlgo()       -->
print(resposta)            --> corrotina concluída!
print(pcall(fazAlgo))      --> false cannot resume dead coroutine
