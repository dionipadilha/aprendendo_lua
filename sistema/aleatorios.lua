-- aleatorios.lua

-- propósito: demonstrar o uso de math.randomseed e math.random

--------------------------------------------------------------------------------
-- math.randomseed:

-- define a semente do gerador de números pseudoaleatórios.

-- sem argumentos: gera uma semente com uma tentativa fraca de aleatoriedade.
print("semente fraca: ", math.randomseed()) --> 1784549451	94646116549288

-- um argumento: define a semente.
math.randomseed(1715878000)

-- dois argumentos: combina os argumentos em uma única semente de 128 bits.
math.randomseed(1715878877, 15471192)

--------------------------------------------------------------------------------
-- math.randomseed aprimorado para melhor aleatoriedade:

-- evite usar math.randomseed sem argumentos
-- usar a mesma semente sempre produzirá a mesma sequência de números aleatórios.

-- truque comum:
print(math.randomseed(os.time())) --> 1784549451	0

-- usando múltiplas fontes de entropia:
local semente_x = os.time()
local semente_y = tonumber(tostring(os.time()):reverse())
print(math.randomseed(semente_x, semente_y)) --> 1784549451	1549454871

--------------------------------------------------------------------------------
-- math.random:

-- fornece funções para gerar números pseudoaleatórios.

-- sem argumentos:
print(math.random()) --> 0.58601668472616

-- apenas um argumento:
print(math.random(6))              --> 5
print(math.random(os.time()))      --> 1560379946
print(math.random(math.random(6))) --> 1

-- intervalo (m, n):
print(math.random(3, 6)) --> 4

--------------------------------------------------------------------------------
-- exemplo #1: seleciona aleatoriamente um item de uma lista

local function escolhaAleatoria(lista)
  local indice = math.random(1, #lista)
  return lista[indice]
end

local cores = { "vermelho", "verde", "azul" }

math.randomseed(os.time())
print(escolhaAleatoria(cores)) --> azul
print(escolhaAleatoria(cores)) --> verde

--------------------------------------------------------------------------------
-- exemplo #2: gera uma string alfanumérica aleatória com o tamanho especificado


local function senhaAleatoria(conjunto_de_caracteres, n)
  local resultado = {}
  for i = 1, n do
    local aleatorio = math.random(1, #conjunto_de_caracteres)
    table.insert(resultado, conjunto_de_caracteres:sub(aleatorio, aleatorio))
  end
  return table.concat(resultado)
end

math.randomseed(os.time())
local conjunto_de_caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
print(senhaAleatoria(conjunto_de_caracteres, 8))  --> ZEZDQzd5
print(senhaAleatoria(conjunto_de_caracteres, 10)) --> Xy0gX1dN7s

--------------------------------------------------------------------------------
-- exemplo #3: gerador de horários aleatórios com intervalo personalizável

local function geradorDeHorarioAleatorio(minimo, maximo)
  local data_e_hora = "%d/%m/%Y %X" -- dd/mm/aaaa hh:mm:ss
  local aleatorio = math.random(minimo, maximo)
  return (os.date(data_e_hora, aleatorio))
end

local agora = os.time()
local dia = 86400 -- 24 * 60 * 60s = 86400s
local minimo = agora - dia
local maximo = agora + dia

math.randomseed(agora)
print(geradorDeHorarioAleatorio(minimo, maximo)) --> 21/07/2026 00:40:30
print(geradorDeHorarioAleatorio(minimo, maximo)) --> 19/07/2026 20:12:25

--------------------------------------------------------------------------------
