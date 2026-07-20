-- selecionar_onde.lua

--------------------------------------------------------------------------------
-- Seleciona os elementos de uma lista onde um dado critério é verdadeiro

local function selecionarOnde(lista, criterio)
  -- Valida as entradas:
  assert(
    type(lista) == "table",
    "Esperava uma tabela como primeiro argumento."
  )
  assert(
    type(criterio) == "function",
    "Esperava uma função como segundo argumento."
  )

  -- Seleciona os elementos que atendem ao critério:
  local listaSelecionada = {}
  for _, elemento in ipairs(lista) do
    if criterio(elemento) then
      table.insert(listaSelecionada, elemento)
    end
  end

  -- Retorna a lista selecionada:
  return listaSelecionada
end

--------------------------------------------------------------------------------
-- Exemplo de uso

-- Lista a ser filtrada:
local numeros = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

-- Funções de critério genéricas:
local ehPar = function(n) return n % 2 == 0 end
local ehImpar = function(n) return n % 2 ~= 0 end

-- Seleciona elementos da lista com base nos critérios:
local numerosPares = selecionarOnde(numeros, ehPar)
local numerosImpares = selecionarOnde(numeros, ehImpar)

-- Imprime as listas selecionadas:
print("Números pares:", table.concat(numerosPares, ", "))   --> 2, 4, 6, 8, 10
print("Números ímpares:", table.concat(numerosImpares, ", ")) --> 1, 3, 5, 7, 9
assert(table.concat(numerosPares, ", ") == "2, 4, 6, 8, 10")
assert(table.concat(numerosImpares, ", ") == "1, 3, 5, 7, 9")

--------------------------------------------------------------------------------
-- Testes unitários

local function testarSelecionarOnde()
  -- Teste #1: Lista vazia
  assert(
    #selecionarOnde({}, ehPar) == 0,
    "Teste falhou: Lista vazia"
  )

  -- Teste #2: Números maiores que 5
  local function ehMaiorQueCinco(n) return n > 5 end
  assert(
    #selecionarOnde(numeros, ehMaiorQueCinco) == 5,
    "Teste falhou: Números maiores que 5"
  )

  -- Teste #3: Números negativos
  local numerosNegativos = { -1, -2, -3, -4, -5 }
  local numerosNegativosPares = selecionarOnde(numerosNegativos, ehPar)
  assert(
    #numerosNegativosPares == 2,
    "Teste falhou: Números negativos pares #3.1"
  )
  assert(
    numerosNegativosPares[1] == -2,
    "Teste falhou: Números negativos pares #3.2"
  )
  assert(
    numerosNegativosPares[2] == -4,
    "Teste falhou: Números negativos pares #3.3"
  )

  -- Teste #4: Tipos de dados diferentes
  local listaMista   = { 1, "dois", 3, "quatro" }
  local ehNumero     = function(n) return type(n) == "number" end
  local apenasNumeros = selecionarOnde(listaMista, ehNumero)
  assert(
    #apenasNumeros == 2 and apenasNumeros[1] == 1 and apenasNumeros[2] == 3,
    "Teste falhou: Lista mista apenas com números"
  )

  -- Todos os testes passaram
  print("Todos os testes passaram.")
end

testarSelecionarOnde()
--------------------------------------------------------------------------------
