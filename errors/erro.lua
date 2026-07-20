-- erro.lua

--------------------------------------------
-- Detalhes:

-- Interrompe a execução e lança um erro.

-- sintaxe: error(mensagem, nivel?)
-- Retorna:

--------------------------------------------
-- Exemplos básicos:
local idade = 1
if idade < 0 then error("log #1: A idade não pode ser negativa.") end
if idade == 0 then error("log #2: A idade não pode ser zero.", 2) end
print("log #3: após o erro.")

--------------------------------------------
-- Veja também: assert, pcall, xpcall
