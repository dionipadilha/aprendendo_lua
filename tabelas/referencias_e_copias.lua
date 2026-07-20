-- referencias_e_copias.lua

-- Tabelas são REFERÊNCIAS: atribuir uma tabela a outra variável cria um
-- apelido para a mesma tabela, não uma cópia. Para copiar de verdade é
-- preciso construir outra tabela (cópia rasa ou profunda).

--------------------------------------------------------------------------------
-- #1. Atribuição cria apelido:

local original = { valor = 1 }
local apelido = original
apelido.valor = 99
assert(original.valor == 99) -- a "outra" tabela é a mesma tabela

-- == entre tabelas compara REFERÊNCIAS, não conteúdo:
assert(original == apelido)
local t1, t2 = { 1, 2 }, { 1, 2 }
assert(t1 ~= t2) -- conteúdo igual, objetos diferentes

--------------------------------------------------------------------------------
-- #2. Cópia rasa: os campos de topo são copiados, mas as sub-tabelas
-- continuam compartilhadas.

local function copiaRasa(t)
  local copia = {}
  for chave, valor in pairs(t) do
    copia[chave] = valor
  end
  return copia
end

local pedido = { numero = 7, itens = { "café" } }
local copiado = copiaRasa(pedido)

copiado.numero = 8
assert(pedido.numero == 7) -- campo de topo: independente...

table.insert(copiado.itens, "leite")
assert(#pedido.itens == 2) -- ...sub-tabela: compartilhada!

--------------------------------------------------------------------------------
-- #3. Cópia profunda: recursiva — as sub-tabelas também são copiadas.
-- (Uma versão para todos os casos ainda trataria ciclos e metatabelas;
-- esta cobre o caso comum.)

local function copiaProfunda(valor)
  if type(valor) ~= "table" then return valor end
  local copia = {}
  for chave, item in pairs(valor) do
    copia[chave] = copiaProfunda(item)
  end
  return copia
end

local independente = copiaProfunda(pedido)
table.insert(independente.itens, "açúcar")
assert(#pedido.itens == 2 and #independente.itens == 3)

--------------------------------------------------------------------------------
-- #4. Conjuntos: o idioma tabela-como-conjunto usa CHAVES — pertinência
-- em O(1), sem varrer lista nenhuma.

local vogais = {}
for letra in ("aeiou"):gmatch(".") do
  vogais[letra] = true
end

assert(vogais["a"] and vogais["u"])
assert(not vogais["b"])

vogais["a"] = nil -- remoção do conjunto
assert(not vogais["a"])

-- união e interseção seguem direto do idioma:
local function uniao(a, b)
  local resultado = {}
  for chave in pairs(a) do resultado[chave] = true end
  for chave in pairs(b) do resultado[chave] = true end
  return resultado
end

local ab = uniao({ a = true }, { b = true })
assert(ab.a and ab.b)

print("Referências, cópias e conjuntos verificados!")
