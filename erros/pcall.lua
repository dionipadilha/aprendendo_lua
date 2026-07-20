-- pcall.lua

--------------------------------------------
-- Detalhes:

-- Executa uma função dentro de um ambiente seguro.

-- Sintaxe: pcall(funcao, arg1, arg2, ...)
-- Retorna: sucesso, resultado1, resultado2, ...

--------------------------------------------
-- Exemplos básicos:

local function divisaoArriscada(x, y)
    assert(y ~= 0, "Divisão por zero")
    return x / y
end

print("#1:", pcall(divisaoArriscada, 8, 4))
print("#2:", pcall(divisaoArriscada, 8, 0))

print("#3:", "após divisaoArriscada #1 e #2.")

--------------------------------------------
-- Veja também: error, assert, xpcall
