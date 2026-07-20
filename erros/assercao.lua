-- assercao.lua

--------------------------------------------
-- Detalhes:

-- assert(condicao, msgErro?) lança um erro quando a condição é falsa
-- (ou seja, false ou nil). Sem mensagem, usa o padrão "assertion failed!".
-- Internamente assert chama error, então mensagens string também ganham
-- o prefixo "arquivo:linha".
-- Retorna: todos os argumentos recebidos, quando a condição é verdadeira.

--------------------------------------------
-- Exemplos básicos:

-- Quando a condição vale, assert devolve os próprios argumentos:
local idade = assert(18, "esta mensagem nunca aparece")
assert(idade == 18)

-- O erro dispara de fato (idade inválida) e é capturado com pcall:
local ok1, mensagem1 = pcall(function()
  local idadeInvalida = 0
  assert(idadeInvalida ~= 0) -- condição falsa: lança o erro padrão
end)
print(mensagem1) --> assercao.lua:22: assertion failed!
assert(not ok1)
assert(mensagem1:match("assercao%.lua:%d+: assertion failed!$"))

-- Com mensagem personalizada:
local ok2, mensagem2 = pcall(function()
  local idadeInvalida = -1
  assert(idadeInvalida > 0, "log #1: A idade deve ser positiva.")
end)
print(mensagem2) --> assercao.lua:31: log #1: A idade deve ser positiva.
assert(not ok2)
assert(mensagem2:match("assercao%.lua:%d+: log #1: A idade deve ser positiva%.$"))

print("log #2: após os erros capturados.")

--------------------------------------------
-- Veja também: error, pcall, xpcall
