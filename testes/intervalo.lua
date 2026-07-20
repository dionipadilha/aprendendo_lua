-- intervalo.lua

-- Gera uma sequência de números, semelhante ao range do Python.

local function tratadorDeEntrada(inicio, fim, passo)
  -- Valida os tipos das entradas:
  assert(type(inicio) == "number", "O valor de início deve ser um número")
  assert(type(fim) == "number" or fim == nil, "O valor de fim deve ser um número ou nil")
  assert(type(passo) == "number" or passo == nil, "O valor do passo deve ser um número ou nil")

  -- Se apenas um argumento for fornecido, ele define o fim:
  if not fim then
    fim, inicio = inicio, 1
  end
  -- O passo padrão é 1 quando não for fornecido:
  passo = passo or 1
  return inicio, fim, passo
end

local function obterIterador(inicio, fim, passo)
  local i = inicio - passo
  return function()
    i = i + passo
    -- Incrementa ou decrementa i com base no valor do passo:
    if passo < 0 then
      -- gera uma sequência decrescente:
      return i >= fim and i or nil
    else
      -- gera uma sequência crescente:
      return i <= fim and i or nil
    end
  end
end

local function intervalo(inicio, fim, passo)
  inicio, fim, passo = tratadorDeEntrada(inicio, fim, passo)
  return obterIterador(inicio, fim, passo)
end

return intervalo
