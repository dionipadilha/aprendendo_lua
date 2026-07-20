-- gerador_com_wrap.lua

-- O uso mais clássico de corrotinas: GERADORES para o for genérico.
-- coroutine.wrap devolve uma função que retoma a corrotina a cada
-- chamada — exatamente o contrato de um iterador de `for ... in`.
-- Quando a corrotina termina, o iterador devolve nil e o laço acaba.

--------------------------------------------------------------------------------
-- #1. Um gerador simples:

local function contador(limite)
  return coroutine.wrap(function()
    for i = 1, limite do
      coroutine.yield(i)
    end
  end)
end

local soma = 0
for i in contador(4) do
  soma = soma + i
end
assert(soma == 10)

--------------------------------------------------------------------------------
-- #2. Onde geradores brilham: percorrer estruturas aninhadas sob
-- demanda, sem montar uma lista intermediária. O yield pode acontecer
-- em qualquer profundidade de chamadas dentro da corrotina:

local function achatar(t)
  return coroutine.wrap(function()
    local function visitar(valor)
      if type(valor) == "table" then
        for _, item in ipairs(valor) do visitar(item) end
      else
        coroutine.yield(valor)
      end
    end
    visitar(t)
  end)
end

local achatados = {}
for valor in achatar({ 1, { 2, { 3, 4 } }, 5 }) do
  table.insert(achatados, valor)
end
assert(table.concat(achatados, ",") == "1,2,3,4,5")

--------------------------------------------------------------------------------
-- #3. Produtor-consumidor: o consumidor PUXA os itens; o produtor fica
-- suspenso entre um item e outro. Aqui com create/resume, para mostrar
-- a diferença para o wrap: resume devolve ok + valores e nunca propaga
-- erros; o wrap devolve os valores diretos e propaga erros.

local function novoProdutor(itens)
  return coroutine.create(function()
    for _, item in ipairs(itens) do
      coroutine.yield(item)
    end
  end)
end

local produtor = novoProdutor { "pão", "leite", "café" }

local recebidos = {}
while true do
  local ok, item = coroutine.resume(produtor)
  assert(ok, item)
  -- nil funciona como sentinela de término aqui porque o produtor
  -- nunca cede nil como item legítimo (os itens são strings):
  if item == nil then break end -- o produtor terminou
  table.insert(recebidos, item)
end

assert(table.concat(recebidos, ", ") == "pão, leite, café")
assert(coroutine.status(produtor) == "dead")

print("Geradores com wrap e produtor-consumidor verificados!")
