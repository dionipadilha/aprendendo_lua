-- par_ou_impar.lua

-- Exercício 1 de documentacao/comece_aqui.md: devolve "par" ou "impar".
-- Tente resolver sozinho antes de ler esta solução!

local function parOuImpar(n)
  assert(math.type(n) == "integer", "a entrada deve ser um inteiro")
  if n % 2 == 0 then
    return "par"
  else
    return "impar"
  end
end

-- Verificação:
assert(parOuImpar(0) == "par")
assert(parOuImpar(1) == "impar")
assert(parOuImpar(42) == "par")
assert(parOuImpar(-3) == "impar") -- o resto de Lua é sempre não negativo: -3 % 2 == 1
assert(not pcall(parOuImpar, 1.5)) -- floats são rejeitados pelo assert

print("par ou ímpar: solução verificada!")
