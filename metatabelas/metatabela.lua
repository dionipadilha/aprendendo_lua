-- metatabela.lua

---------------------------------------------------------
-- Sem metatabelas: somar tabelas com "+" gera um erro.

local t1 = { 1, 3, 5 }
local t2 = { 2, 4, 6 }

local ok = pcall(function() return t1 + t2 end)
assert(ok == false) --> attempt to perform arithmetic on a table value

---------------------------------------------------------
-- Metatabelas: personalizam o comportamento das tabelas Lua.

-- __add PURO: não modifica os operandos; retorna uma NOVA tabela com os
-- elementos ordenados. A nova tabela recebe a mesma metatabela, herdando
-- __tostring (para imprimir bonito) e o próprio __add.
local mt = {}

mt.__add = function(a, b)
  local resultado = {}
  table.move(a, 1, #a, 1, resultado)
  table.move(b, 1, #b, #a + 1, resultado)
  table.sort(resultado)
  return setmetatable(resultado, mt)
end

mt.__tostring = function(t)
  return table.concat(t, ", ")
end

local t3 = setmetatable({ 1, 3, 5 }, mt)
local t4 = { 2, 4, 6 } -- basta UM dos operandos ter a metatabela

local soma = t3 + t4
print(soma) --> 1, 2, 3, 4, 5, 6
assert(tostring(soma) == "1, 2, 3, 4, 5, 6")

-- O resultado é uma nova tabela, que herda a metatabela:
assert(soma ~= t3 and soma ~= t4)
assert(getmetatable(soma) == mt)

-- Os operandos ficam intactos após a soma:
assert(#t3 == 3 and t3[1] == 1 and t3[2] == 3 and t3[3] == 5)
assert(#t4 == 3 and t4[1] == 2 and t4[2] == 4 and t4[3] == 6)

-- Como o resultado herda __add, dá para encadear somas:
local somaEncadeada = soma + { 0, 7 }
print(somaEncadeada) --> 0, 1, 2, 3, 4, 5, 6, 7
assert(tostring(somaEncadeada) == "0, 1, 2, 3, 4, 5, 6, 7")
---------------------------------------------------------
