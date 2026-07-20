-- lacos.lua

-- Os laços de Lua em versão executável: while, repeat, for numérico
-- (com passo, inclusive negativo) e break.

--------------------------------------------------------------------------------
-- #1. while: testa ANTES de executar — pode rodar zero vezes.

local contagem = 0
while contagem < 3 do
  contagem = contagem + 1
end
assert(contagem == 3)

--------------------------------------------------------------------------------
-- #2. repeat: testa DEPOIS — executa ao menos uma vez. E o until
-- enxerga as variáveis locais declaradas no corpo do laço:

local tentativas = 0
repeat
  tentativas = tentativas + 1
  local sucesso = (tentativas == 2)
until sucesso -- `sucesso` é local do corpo e ainda está visível aqui
assert(tentativas == 2)

--------------------------------------------------------------------------------
-- #3. for numérico: início, fim e passo (avaliados uma única vez).

local soma = 0
for i = 1, 5 do soma = soma + i end
assert(soma == 15)

-- passo negativo — contagem regressiva:
local regressiva = {}
for i = 3, 1, -1 do table.insert(regressiva, i) end
assert(table.concat(regressiva, ",") == "3,2,1")

-- quando o início já "passou" do fim, o laço não executa nenhuma vez:
local vezes = 0
for _ = 1, 0 do vezes = vezes + 1 end
assert(vezes == 0)

-- a variável de controle é LOCAL do laço: alterá-la não muda a iteração.
-- (o luacheck é silenciado porque atribuir sem ler É a demonstração)
local iteracoes = 0
for i = 1, 3 do -- luacheck: ignore 233
  i = 100 -- não afeta o andamento do laço
  iteracoes = iteracoes + 1
end
assert(iteracoes == 3)

--------------------------------------------------------------------------------
-- #4. break: interrompe o laço.

local valores = { 10, 20, 30, 40 }
local posicao
for indice, valor in ipairs(valores) do
  if valor == 30 then
    posicao = indice
    break -- sai do laço: o 40 nem chega a ser visitado
  end
end
assert(posicao == 3)

-- break sai apenas do laço MAIS INTERNO:
local voltasExternas = 0
for _ = 1, 2 do
  for j = 1, 10 do
    if j == 1 then break end -- interrompe só o laço interno
  end
  voltasExternas = voltasExternas + 1
end
assert(voltasExternas == 2) -- o laço externo completou as duas voltas

-- (não existe `continue` em Lua; o idioma equivalente, com goto,
-- está em goto.lua)

print("Laços while, repeat, for e break verificados!")
