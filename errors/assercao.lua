-- assercao.lua

--------------------------------------------
-- Detalhes:

-- Lança um erro com base em uma condição.

-- sintaxe: assert(condicao, [msgErro])
-- Retorna:

--------------------------------------------
-- Exemplos básicos:
local idade = 1
assert(idade ~= 0) --> assertion failed!
assert(idade > 0, "log#1: A idade deve ser positiva.")
print("log #2: após o erro.")

--------------------------------------------
-- Veja também: error, pcall, xpcall
