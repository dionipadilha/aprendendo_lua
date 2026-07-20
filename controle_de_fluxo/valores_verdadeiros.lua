-- valores_verdadeiros.lua

-- Em Lua, uma condição pode ser QUALQUER valor:
-- apenas `nil` e `false` contam como falsos;
-- TODOS os outros valores contam como verdadeiros — inclusive 0 e "".

-- Função auxiliar: devolve true se Lua tratar o valor como verdadeiro:
local function ehVerdadeiro(valor)
  if valor then return true else return false end
end

-- Só nil e false são falsos:
assert(ehVerdadeiro(nil) == false)
assert(ehVerdadeiro(false) == false)

-- 0 é verdadeiro (diferente de C, Python e JavaScript):
assert(ehVerdadeiro(0) == true)
if 0 then print("0 é verdadeiro em Lua") end --> 0 é verdadeiro em Lua

-- A string vazia também é verdadeira:
assert(ehVerdadeiro("") == true)
if "" then print('"" (string vazia) é verdadeira em Lua') end --> "" (string vazia) é verdadeira em Lua

-- Outros valores igualmente verdadeiros:
assert(ehVerdadeiro(0.0) == true)      -- zero float
assert(ehVerdadeiro("falso") == true)  -- qualquer string, mesmo "falso"
assert(ehVerdadeiro({}) == true)       -- tabela, mesmo vazia
assert(ehVerdadeiro(print) == true)    -- funções

-- Consequência nos operadores lógicos:
-- `and` e `or` devolvem um dos OPERANDOS, não um booleano:
assert((0 and "sim") == "sim")        -- 0 é verdadeiro: avalia o segundo operando
assert(("" or "padrao") == "")        -- "" é verdadeira: curto-circuito devolve ""
assert((nil or "padrao") == "padrao") -- nil é falso: devolve a alternativa
assert((false and "sim") == false)    -- false é falso: curto-circuito devolve false

-- Por isso o idioma de valor padrão `x = x or padrao` FALHA
-- quando o valor legítimo é false (false or padrao devolve padrao):
assert((false or "padrao") == "padrao")

print("Todos os asserts passaram: só nil e false são falsos.")
