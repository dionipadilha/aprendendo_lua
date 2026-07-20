-- aleatorios.lua

-- propósito: demonstrar o uso de math.randomseed e math.random
-- (saídas aleatórias variam a cada execução; os asserts verificam
-- propriedades — tipo e faixa — em vez de valores exatos)

--------------------------------------------------------------------------------
-- math.randomseed:

-- define a semente do gerador de números pseudoaleatórios.

-- sem argumentos: gera uma semente com uma tentativa fraca de aleatoriedade.
print("semente fraca: ", math.randomseed()) --> dois inteiros (variam)

-- um argumento: define a semente.
math.randomseed(1715878000)

-- dois argumentos: combina os argumentos em uma única semente de 128 bits.
math.randomseed(1715878877, 15471192)

--------------------------------------------------------------------------------
-- math.randomseed aprimorado para melhor aleatoriedade:

-- evite usar math.randomseed sem argumentos
-- usar a mesma semente sempre produzirá a mesma sequência de números aleatórios.

-- truque comum:
print(math.randomseed(os.time())) --> os componentes da semente (variam)

-- usando múltiplas fontes de entropia:
local sementeX = os.time()
local sementeY = tonumber(tostring(os.time()):reverse())
print(math.randomseed(sementeX, sementeY)) --> os componentes da semente (variam)

--------------------------------------------------------------------------------
-- math.random:

-- fornece funções para gerar números pseudoaleatórios.

-- sem argumentos: float no intervalo [0, 1)
local flutuante = math.random()
print(flutuante) --> 0.58601668472616 (varia)
assert(type(flutuante) == "number" and flutuante >= 0 and flutuante < 1)

-- apenas um argumento: inteiro no intervalo [1, m]
local dado = math.random(6)
print(dado) --> 5 (varia)
assert(math.type(dado) == "integer" and dado >= 1 and dado <= 6)

-- intervalo (m, n): inteiro no intervalo [m, n]
local sorteado = math.random(3, 6)
print(sorteado) --> 4 (varia)
assert(math.type(sorteado) == "integer" and sorteado >= 3 and sorteado <= 6)

--------------------------------------------------------------------------------
-- exemplo #1: seleciona aleatoriamente um item de uma lista

local function escolhaAleatoria(lista)
  local indice = math.random(1, #lista)
  return lista[indice]
end

local cores = { "vermelho", "verde", "azul" }

math.randomseed(os.time())
local corEscolhida = escolhaAleatoria(cores)
print(corEscolhida) --> azul (varia)

-- propriedade: a escolha sempre pertence à lista
local pertence = false
for _, cor in ipairs(cores) do
  if cor == corEscolhida then pertence = true end
end
assert(pertence)

--------------------------------------------------------------------------------
-- exemplo #2: gera uma string alfanumérica aleatória com o tamanho especificado

local function senhaAleatoria(conjuntoDeCaracteres, n)
  local resultado = {}
  for i = 1, n do
    local aleatorio = math.random(1, #conjuntoDeCaracteres)
    table.insert(resultado, conjuntoDeCaracteres:sub(aleatorio, aleatorio))
  end
  return table.concat(resultado)
end

math.randomseed(os.time())
local conjuntoDeCaracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local senha8 = senhaAleatoria(conjuntoDeCaracteres, 8)
local senha10 = senhaAleatoria(conjuntoDeCaracteres, 10)
print(senha8)  --> ZEZDQzd5 (varia)
print(senha10) --> Xy0gX1dN7s (varia)

-- propriedades: tamanho pedido e apenas caracteres alfanuméricos
assert(#senha8 == 8 and senha8:match("^%w+$"))
assert(#senha10 == 10 and senha10:match("^%w+$"))

--------------------------------------------------------------------------------
-- exemplo #3: gerador de horários aleatórios com intervalo personalizável

local function geradorDeHorarioAleatorio(minimo, maximo)
  local formatoDataEHora = "%d/%m/%Y %X" -- dd/mm/aaaa hh:mm:ss
  local aleatorio = math.random(minimo, maximo)
  return (os.date(formatoDataEHora, aleatorio))
end

local agora = os.time()
local dia = 86400 -- 24 * 60 * 60s = 86400s
local minimo = agora - dia
local maximo = agora + dia

math.randomseed(agora)
local horario1 = geradorDeHorarioAleatorio(minimo, maximo)
local horario2 = geradorDeHorarioAleatorio(minimo, maximo)
print(horario1) --> 21/07/2026 00:40:30 (varia)
print(horario2) --> 19/07/2026 20:12:25 (varia)

-- propriedade: o formato é sempre dd/mm/aaaa hh:mm:ss
local formatoEsperado = "^%d%d/%d%d/%d%d%d%d %d%d:%d%d:%d%d$"
assert(horario1:match(formatoEsperado))
assert(horario2:match(formatoEsperado))

--------------------------------------------------------------------------------
