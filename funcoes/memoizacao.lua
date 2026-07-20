-- memoizacao.lua
-- Armazena resultados em cache para evitar cálculos redundantes.

-- Inicializa o cache de memoização com o caso base: 0! = 1
local cache = { [0] = 1 }

-- Função fatorial com memoização.
-- A etiqueta do segundo retorno existe nos DOIS caminhos de propósito:
-- se só o acerto de cache a devolvesse, o NÚMERO de retornos variaria
-- com o estado interno — surpresa para contextos que preservam retornos
-- múltiplos, como print e table.pack (regras em multiplos_retornos.lua).
local function fatorial(n)
  -- Trata entradas negativas
  assert(n >= 0, "O fatorial não é definido para números negativos")

  -- Verifica resultados memoizados:
  if cache[n] then
    return cache[n], "recuperado do cache"
  end

  -- Memoiza o fatorial calculado recursivamente (a multiplicação ajusta
  -- a chamada recursiva para 1 valor, descartando a etiqueta interna):
  cache[n] = n * fatorial(n - 1)
  return cache[n], "calculado"
end

-- Exemplo de uso
local function testeMemoizacao()
  print(fatorial(5)) --> 120	calculado
  print(fatorial(6)) --> 720	calculado
  print(fatorial(7)) --> 5040	calculado
  print(fatorial(5)) --> 120	recuperado do cache
  print(fatorial(6)) --> 720	recuperado do cache
end

testeMemoizacao()

-- Verificação: valores corretos e etiqueta refletindo o estado do cache
local valor, origem = fatorial(5)
assert(valor == 120 and origem == "recuperado do cache")
local valorNovo, origemNova = fatorial(9)
assert(valorNovo == 362880 and origemNova == "calculado")
local valorRepetido, origemRepetida = fatorial(9) -- mesma chamada, mesma aridade
assert(valorRepetido == 362880 and origemRepetida == "recuperado do cache")
-- 8! entrou no cache como passo intermediário do cálculo de 9!:
local valorIntermediario, origemIntermediaria = fatorial(8)
assert(valorIntermediario == 40320 and origemIntermediaria == "recuperado do cache")
assert(not pcall(fatorial, -1)) -- entradas negativas disparam o erro
