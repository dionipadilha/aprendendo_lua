-- teste_intervalo.lua

-- Testes do módulo intervalo.lua, com asserts DE TOPO: qualquer falha
-- derruba a execução com código de saída diferente de zero.

local intervalo = require "intervalo"

local function sequencia(iteradorDeIntervalo)
  local t = {}
  for n in iteradorDeIntervalo do table.insert(t, n) end
  return table.concat(t, ", ")
end

------------------------------------------------------------
-- Casos normais:

assert(sequencia(intervalo(3)) == "1, 2, 3", "teste #1")
assert(sequencia(intervalo(3, 6)) == "3, 4, 5, 6", "teste #2")
assert(sequencia(intervalo(3, 9, 2)) == "3, 5, 7, 9", "teste #3")
assert(sequencia(intervalo(-6, -3, 1)) == "-6, -5, -4, -3", "teste #4")
assert(sequencia(intervalo(6, 3, -1)) == "6, 5, 4, 3", "teste #5")

------------------------------------------------------------
-- Casos limite (sequências vazias):

assert(sequencia(intervalo(0)) == "", "teste #6")
assert(sequencia(intervalo(-3)) == "", "teste #7")
assert(sequencia(intervalo(9, 6)) == "", "teste #8")
assert(sequencia(intervalo(9, 6, 2)) == "", "teste #9")
assert(sequencia(intervalo(6, 9, -2)) == "", "teste #10")

------------------------------------------------------------
-- Entradas inválidas devem lançar erro (capturado com pcall):

local ok, erro = pcall(intervalo, "3")
assert(not ok, "teste #11: intervalo('3') deveria ter lançado um erro")
assert(erro:match("O valor de início deve ser um número"), "teste #11: mensagem inesperada")

------------------------------------------------------------
-- Exemplo de tratador de erros com xpcall:
-- o tratador formata a exceção, e os asserts sobre o RESULTADO do xpcall
-- ficam no topo — asserts dentro do xpcall não afetariam o código de saída.

local function usoInvalido()
  return intervalo(1, 5, "2")
end

local function tratadorDeErro(msgDeErro)
  return "Falha capturada: " .. msgDeErro
end

local okXpcall, relatorio = xpcall(usoInvalido, tratadorDeErro)
assert(not okXpcall, "teste #12: usoInvalido deveria falhar")
assert(relatorio:match("^Falha capturada: "), "teste #12: o tratador deveria formatar a mensagem")
print(relatorio)

------------------------------------------------------------
-- Uso da função como sequência:

local quadrados = {}
for n in intervalo(1, 5, 2) do
  print(n, n ^ 2)
  table.insert(quadrados, n ^ 2)
end
--> 1	1.0
--> 3	9.0
--> 5	25.0
assert(table.concat(quadrados, ", ") == "1.0, 9.0, 25.0")

print("O módulo intervalo lida corretamente com todos os cenários!")
