-- erro.lua

--------------------------------------------
-- Detalhes:

-- error(mensagem, nivel?) interrompe a execução e lança um erro.
-- Quando a mensagem é uma string, Lua acrescenta o prefixo "arquivo:linha".
-- O parâmetro nivel escolhe QUAL linha aparece no prefixo:
--   nivel 1 (padrão): a linha onde error foi chamado;
--   nivel 2: a linha de quem chamou a função que lançou o erro;
--   nivel 0: nenhuma informação de posição.

--------------------------------------------
-- Exemplos básicos:

local function validarIdade(idade)
  if idade < 0 then error("a idade não pode ser negativa") end -- nivel 1 (padrão)
  if idade == 0 then error("a idade não pode ser zero", 2) end -- nivel 2: culpa quem chamou
  return idade
end

local function cadastrar(idade)
  -- Com nivel 2, o prefixo do erro aponta para ESTA chamada.
  -- (Não usamos "return validarIdade(idade)" porque a chamada de cauda
  -- descartaria o quadro de cadastrar da pilha e o nivel 2 ficaria sem posição.)
  local idadeValidada = validarIdade(idade)
  return idadeValidada
end

-- O erro dispara de fato e é capturado com pcall:
local ok1, mensagem1 = pcall(validarIdade, -1)
print(mensagem1) --> erro.lua:17: a idade não pode ser negativa
assert(not ok1)
assert(mensagem1:match("erro%.lua:%d+: a idade não pode ser negativa$"))

-- Com nivel 2, o prefixo aponta para a linha da chamada em cadastrar:
local ok2, mensagem2 = pcall(cadastrar, 0)
print(mensagem2) --> erro.lua:26: a idade não pode ser zero
assert(not ok2)
assert(mensagem2:match("erro%.lua:%d+: a idade não pode ser zero$"))

-- Prova de que nivel 2 apontou para a chamada (mais abaixo no arquivo)
-- e não para a linha do próprio error (dentro de validarIdade):
local linhaNivel1 = tonumber(mensagem1:match(":(%d+):"))
local linhaNivel2 = tonumber(mensagem2:match(":(%d+):"))
assert(linhaNivel2 > linhaNivel1)

-- Com nivel 0, a mensagem chega sem prefixo de posição:
local ok3, mensagem3 = pcall(function() error("sem prefixo", 0) end)
print(mensagem3) --> sem prefixo
assert(not ok3)
assert(mensagem3 == "sem prefixo")

-- O caminho feliz continua funcionando:
assert(validarIdade(18) == 18)
print("log final: erros capturados; execução continua.")

--------------------------------------------
-- Veja também: assert, pcall, xpcall, objetos_de_erro
