-- intervalo.lua

-- Gera uma sequência de números.

local function tratadorDeEntrada(inicio, fim, passo)
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
