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
assert(coroutine.status(co) == "suspended")

-- Retoma a corrotina com um valor inicial:
local sucesso, resposta = coroutine.resume(co, "bob")
print(sucesso, resposta, coroutine.status(co)) --> true	dadoInicial: bob	suspended
assert(sucesso == true and resposta == "dadoInicial: bob")
assert(coroutine.status(co) == "suspended")

-- Retoma a corrotina com um novo valor:
sucesso, resposta = coroutine.resume(co, 42)
print(sucesso, resposta, coroutine.status(co)) --> true	novoDado: 42	suspended
assert(sucesso == true and resposta == "novoDado: 42")
assert(coroutine.status(co) == "suspended")

-- Retoma a corrotina sem valor; a conclusão normal retorna true e o valor final:
sucesso, resposta = coroutine.resume(co)
print(sucesso, resposta, coroutine.status(co)) --> true	bob42	dead
assert(sucesso == true and resposta == "bob42")
assert(coroutine.status(co) == "dead")
