-- Valores de retorno

-- Valor de retorno:
local function somar(x, y)
  return x + y
end
local soma = somar(2, 3)
print(soma) --> 5

-- Múltiplos valores de retorno:
local function somaProduto(x, y)
  return x + y, x * y
end
local soma, produto = somaProduto(2, 3)
print(soma, produto) --> 5 6

-- Retornando com base em uma condição:
local function maximo(x, y)
  return x > y and x or y
end
print(maximo(2, 3)) --> 3

-- Retornando uma tabela:
local function obterOperacoesBasicas(x, y)
  return {
    soma = x + y,
    diferenca = x - y,
    produto = x * y,
    quociente = x / y
  }
end
local resultado = obterOperacoesBasicas(2, 3)
print(resultado.soma, resultado.produto) --> 5 6

-- Retornando uma função:
local function multiplicador(fator)
  return function(x)
    return x * fator
  end
end
local dobro = multiplicador(2)
local triplo = multiplicador(3)
print(dobro(5))  --> 10
print(triplo(5)) --> 15

-- Retornando uma clausura:
local function contador()
  local contagem = 0
  return function()
    contagem = contagem + 1
    return contagem
  end
end
local contar = contador()
print(contar()) --> 1
print(contar()) --> 2
print(contar()) --> ...

-- Retornando uma função recursiva:
local function fatorial(n)
  if n == 0 then return 1
  else return n * fatorial(n - 1)
  end
end
print(fatorial(5)) --> 120

-- Retornando um número variável de valores:
local function empacotar(...)
  return {...}
end
local valores = empacotar(1, 2, 3, "olá")
for _, v in ipairs(valores) do
  print(v) --> 1, 2, 3, olá
end
