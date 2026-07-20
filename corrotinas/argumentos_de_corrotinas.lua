-- argumentos_de_corrotinas.lua

-- Cria uma função de corrotina:
local function fazAlgo(dadoInicial)
  local novoDado = coroutine.yield("dadoInicial: " .. dadoInicial)
  coroutine.yield("novoDado: " .. tostring(novoDado))
  return dadoInicial .. tostring(novoDado)
end

-- Cria um objeto de corrotina:
local co = coroutine.create(fazAlgo)
print(coroutine.status(co)) --> suspended

-- Retoma a corrotina com um valor inicial:
local sucesso, resposta = coroutine.resume(co, "bob")
print(sucesso, resposta, coroutine.status(co)) --> dadoInicial: bob suspended

-- Retoma a corrotina com um novo valor:
sucesso, resposta = coroutine.resume(co, 42)
print(sucesso, resposta, coroutine.status(co)) --> novoDado: 42 suspended

-- Retoma a corrotina sem valor:
sucesso, resposta = coroutine.resume(co)
print(sucesso, resposta, coroutine.status(co)) --> false bob42 dead
