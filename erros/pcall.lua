-- pcall.lua

--------------------------------------------
-- Detalhes:

-- Executa uma função em modo protegido (protected mode).

-- Sintaxe: pcall(funcao, arg1, arg2, ...)
-- Retorna: sucesso, resultado1, resultado2, ...

--------------------------------------------
-- Exemplos básicos:

local function divisaoArriscada(x, y)
  assert(y ~= 0, "Divisão por zero")
  return x / y
end

local ok1, resultado1 = pcall(divisaoArriscada, 8, 4)
print("#1:", ok1, resultado1) --> #1:	true	2.0
assert(ok1)
assert(resultado1 == 2.0)

local ok2, mensagem2 = pcall(divisaoArriscada, 8, 0)
print("#2:", ok2, mensagem2) --> #2:	false	pcall.lua:15: Divisão por zero
assert(not ok2)
assert(mensagem2:match("Divisão por zero$"))

print("#3:", "após divisaoArriscada #1 e #2.")

--------------------------------------------
-- Veja também: error, assert, xpcall
