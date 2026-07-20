-- comparacao.lua

-- Metamétodos de comparação: __eq (==), __lt (<) e __le (<=).
-- Lua deriva os demais operadores:  a ~= b  é  not (a == b);
-- a > b  é  b < a;  a >= b  é  b <= a.
-- __eq só é consultado quando os DOIS operandos são tabelas (ou os
-- dois são full userdata) — e nunca quando já são o mesmo objeto.

local Fracao = {}
Fracao.__index = Fracao

function Fracao.nova(numerador, denominador)
  assert(type(denominador) == "number" and denominador > 0,
    "o denominador deve ser um número positivo")
  return setmetatable({ n = numerador, d = denominador }, Fracao)
end

-- igualdade de VALOR (frações equivalentes são iguais), por
-- multiplicação cruzada — válida porque os denominadores são positivos:
Fracao.__eq = function(a, b)
  return a.n * b.d == b.n * a.d
end

Fracao.__lt = function(a, b)
  return a.n * b.d < b.n * a.d
end

Fracao.__le = function(a, b)
  return a.n * b.d <= b.n * a.d
end

--------------------------------------------------------------------------------

local umMeio = Fracao.nova(1, 2)
local doisQuartos = Fracao.nova(2, 4)
local tresQuartos = Fracao.nova(3, 4)

-- __eq: igualdade de valor, não de referência:
assert(umMeio == doisQuartos)
assert(umMeio ~= tresQuartos) -- ~= é a negação do próprio __eq

-- sem o metamétodo, tabelas de conteúdo igual seriam diferentes;
-- rawequal ignora __eq e mostra isso:
assert(rawequal(umMeio, doisQuartos) == false)

-- __lt e __le; > e >= são derivados invertendo os operandos:
assert(umMeio < tresQuartos)
assert(tresQuartos > umMeio)
assert(umMeio <= doisQuartos)
assert(tresQuartos >= umMeio)

-- comparar uma fração com outro TIPO nunca consulta __eq: é só false
-- (sem erro) — igualdade entre tipos diferentes é sempre falsa:
assert((umMeio == 0.5) == false)

print("Comparações com __eq, __lt e __le verificadas!")
