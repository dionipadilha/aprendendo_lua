-- corrotina_com_wrap.lua

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
assert(resposta == "cedendo #1")

resposta = fazAlgo()       --> fazAlgo #2
print(resposta)            --> cedendo #2
assert(resposta == "cedendo #2")

resposta = fazAlgo()       -->
print(resposta)            --> corrotina concluída!
assert(resposta == "corrotina concluída!")

-- ao contrário de resume, a função de wrap LANÇA o erro; capture com pcall:
local ok, erro = pcall(fazAlgo)
print(ok, erro)            --> false	cannot resume dead coroutine
assert(ok == false and erro == "cannot resume dead coroutine")
