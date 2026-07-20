-- intervalo.lua
-- Gera uma sequência semelhante ao range do Python.

------------------------------------------------------------
-- Definição da função:

local function tratadorDeEntradaDoIntervalo(inicio, fim, passo)
  -- Verifica se as entradas são números ou nil:
  local msgsDeErroDeEntrada = {
    "O valor de início deve ser um número",
    "O valor de fim deve ser um número ou nil",
    "O valor do passo deve ser um número ou nil"
  }
  assert(type(inicio) == "number", msgsDeErroDeEntrada[1])
  assert(type(fim) == "number" or fim == nil, msgsDeErroDeEntrada[2])
  assert(type(passo) == "number" or passo == nil, msgsDeErroDeEntrada[3])

  -- Se apenas um argumento for fornecido, então:
  -- * ele é considerado o valor de 'fim'
  -- * e 'inicio' é definido como 1 por padrão.
  if not fim then fim, inicio = inicio, 1 end

  -- Obtém o valor padrão de 'passo':
  passo = passo or 1
  return inicio, fim, passo
end

local function criarIteradorDeIntervalo(inicio, fim, passo)
  local i = inicio - passo
  return function()
    i = i + passo
    -- Incrementa ou decrementa i com base no valor do passo:
    if passo < 0 then -- gera uma sequência decrescente:
      return i >= fim and i or nil
    else              -- gera uma sequência crescente:
      return i <= fim and i or nil
    end
  end
end

local function intervalo(inicio, fim, passo)
  inicio, fim, passo = tratadorDeEntradaDoIntervalo(inicio, fim, passo)
  local iteradorDeIntervalo = criarIteradorDeIntervalo(inicio, fim, passo)
  return iteradorDeIntervalo
end

------------------------------------------------------------
-- Validação da função:

-- Uso esperado:
local function executar(iteradorDeIntervalo)
  -- coleta todos os valores em uma tabela:
  local elementos = {}
  for n in iteradorDeIntervalo do table.insert(elementos, n) end

  -- formata os elementos da tabela em uma string:
  local resultadoFormatado = table.concat(elementos, ", ")
  return resultadoFormatado
end

local testes = {
  intervalo(3),         -- apenas um argumento
  intervalo(2, 5),      -- dois argumentos
  intervalo(2, 6, 2),   -- todos os argumentos
  intervalo(-5, -1, 2), -- início/fim negativos
  intervalo(5, 1, -2),  -- passo negativo
}

local esperados = {
  "1, 2, 3",
  "2, 3, 4, 5",
  "2, 4, 6",
  "-5, -3, -1",
  "5, 3, 1",
  "1, 3, 5, 7, 9"
}

local function executarTestesUnitarios()
  -- Uso esperado:
  local msgDeFalha = "Falha no teste #%d: %s, obtido %s."
  for n, teste in ipairs(testes) do
    local obtido = executar(teste)
    local msgDeErro = string.format(msgDeFalha, n, esperados[n], obtido)
    assert(esperados[n] == obtido, msgDeErro)
  end

  -- Entradas que não são números devem lançar um erro; capture-o com pcall:
  local ok, erro = pcall(intervalo, "3")
  assert(not ok, "intervalo('3') deveria ter lançado um erro")
  print("Erro esperado capturado: " .. erro)
end

executarTestesUnitarios()
------------------------------------------------------------
-- Uso da função:

-- Usa intervalo como uma sequência:
local numerosImpares = intervalo(1, 5, 2)
for n in numerosImpares do print(n, n ^ 2) end
--> 1 1.0
--> 3 9.0
--> 5 25.0

------------------------------------------------------------
return intervalo
