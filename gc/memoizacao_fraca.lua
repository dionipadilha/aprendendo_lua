-- memoizacao_fraca.lua

-- O caso de uso canônico de tabelas fracas: um cache de memoização que
-- NÃO impede a coleta das chaves. Com __mode = "k", a entrada do cache
-- desaparece junto com o objeto; sem o __mode, o cache seguraria cada
-- chave para sempre — um vazamento de memória clássico.
-- (a técnica de memoização em si está em ../funcoes/memoizacao.lua)

local calculos = 0

-- cache com CHAVES fracas, indexado pelo próprio objeto:
local cache = setmetatable({}, { __mode = "k" })

local function resumo(pedido)
  if cache[pedido] == nil then
    calculos = calculos + 1
    cache[pedido] = ("pedido de %s: %d item(ns)")
        :format(pedido.cliente, #pedido.itens)
  end
  return cache[pedido]
end

local function contarEntradas(t)
  local n = 0
  for _ in pairs(t) do n = n + 1 end
  return n
end

--------------------------------------------------------------------------------
-- #1. O cache funciona: o cálculo roda uma única vez por objeto.

local pedidoDaAna = { cliente = "ana", itens = { "café", "bolo" } }
assert(resumo(pedidoDaAna) == "pedido de ana: 2 item(ns)")
assert(resumo(pedidoDaAna) == "pedido de ana: 2 item(ns)")
assert(calculos == 1) -- a segunda chamada veio do cache

--------------------------------------------------------------------------------
-- #2. E não vaza: sumindo a última referência forte ao pedido, a
-- entrada do cache é coletada junto.

local pedidoTemporario = { cliente = "bob", itens = { "chá" } }
resumo(pedidoTemporario)
assert(contarEntradas(cache) == 2)

pedidoTemporario = nil
collectgarbage("collect")
assert(contarEntradas(cache) == 1) -- a entrada do bob se foi
assert(cache[pedidoDaAna] ~= nil)  -- a da ana (ainda referenciada) ficou

--------------------------------------------------------------------------------
-- #3. Ephemerons (Lua >= 5.2): em uma tabela de chaves fracas, um VALOR
-- que referencia a própria chave não a mantém viva. Antes dos
-- ephemerons, um par assim ficava preso para sempre.

local pares = setmetatable({}, { __mode = "k" })

local chave = {}
pares[chave] = { dona = chave } -- o valor aponta de volta para a chave

chave = nil
collectgarbage("collect")
assert(contarEntradas(pares) == 0, "o ciclo valor->chave deveria ser coletado")

print("Memoização com tabelas fracas e ephemerons verificadas!")
