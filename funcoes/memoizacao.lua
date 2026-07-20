-- memoizacao.lua
-- Armazena resultados em cache para evitar cálculos redundantes.

-- Inicializa o cache de memoização com o caso base: 0! = 1
local cache = { [0] = 1 }

-- Função fatorial com memoização
local function fatorial(n)
  -- Trata entradas negativas
  assert(n >= 0, "O fatorial não é definido para números negativos")

  -- Verifica resultados memoizados:
  if cache[n] then
    return cache[n], "recuperado do cache"
  end

  -- Memoiza o fatorial calculado recursivamente
  cache[n] = n * fatorial(n - 1)
  return cache[n]
end

-- Exemplo de uso
local function testeMemoizacao()
  print(fatorial(5)) --> 120
  print(fatorial(6)) --> 720
  print(fatorial(7)) --> 5040
  print(fatorial(5)) --> 120	recuperado do cache
  print(fatorial(6)) --> 720	recuperado do cache
end

testeMemoizacao()

-- Verificação: valores corretos e segunda chamada vinda do cache
local valor, origem = fatorial(5)
assert(valor == 120 and origem == "recuperado do cache")
assert(fatorial(8) == 40320)
assert(not pcall(fatorial, -1)) -- entradas negativas disparam o erro
