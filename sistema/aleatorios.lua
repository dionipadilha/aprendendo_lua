-- aleatorios.lua

-- propósito: demonstrar o uso de math.randomseed e math.random
-- (saídas aleatórias variam a cada execução; os asserts verificam
-- propriedades — tipo e faixa — em vez de valores exatos)

--------------------------------------------------------------------------------
-- math.randomseed:

-- define a semente do gerador de números pseudoaleatórios.

-- Em Lua 5.4 normalmente NÃO é preciso semear: o interpretador já
-- inicializa o gerador com uma semente de boa entropia a cada execução.

-- sem argumentos: re-semeia com entropia fresca (combina a hora com o
-- endereço de um objeto interno) e devolve os dois componentes usados.
print("semente nova: ", math.randomseed()) --> dois inteiros (variam)

-- um argumento: define a semente exata. O uso legítimo é a
-- REPRODUTIBILIDADE: a mesma semente produz sempre a mesma sequência
-- (útil para depurar e para testes determinísticos).
math.randomseed(42)
local a1, a2, a3 = math.random(1000), math.random(1000), math.random(1000)
math.randomseed(42) -- mesma semente: a sequência REINICIA do começo
local b1, b2, b3 = math.random(1000), math.random(1000), math.random(1000)
assert(a1 == b1 and a2 == b2 and a3 == b3,
  "a mesma semente deve reproduzir a mesma sequência")

-- dois argumentos: combina os argumentos em uma única semente de 128 bits.
math.randomseed(1715878877, 15471192)

-- CUIDADO com o idioma legado math.randomseed(os.time()): era necessário
-- em Lua 5.1/5.2, que não semeavam sozinhas, mas em 5.4 é uma semente
-- PIOR que a automática — os.time() tem resolução de 1 segundo, então
-- dois processos iniciados no mesmo segundo produzem a MESMA sequência.
-- Pelo mesmo motivo, nunca re-semeie "antes de cada uso": re-semear
-- REINICIA a sequência em vez de melhorá-la. Semeie no máximo uma vez,
-- no início do programa — ou não semeie e confie na semente automática.

-- Os exemplos abaixo usam a semente automática: re-semeamos uma única
-- vez, sem argumentos, só para desfazer as sementes fixas didáticas
-- acima (senão a saída seria idêntica em toda execução).
math.randomseed()

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
  -- %X é a hora no formato do LOCALE; o interpretador roda no locale C,
  -- onde vira hh:mm:ss — veja a discussão em data_e_hora.lua.
  local formatoDataEHora = "%d/%m/%Y %X" -- dd/mm/aaaa hh:mm:ss (locale C)
  local aleatorio = math.random(minimo, maximo)
  return (os.date(formatoDataEHora, aleatorio))
end

local agora = os.time()
local dia = 86400 -- 24 * 60 * 60s = 86400s
local minimo = agora - dia
local maximo = agora + dia

local horario1 = geradorDeHorarioAleatorio(minimo, maximo)
local horario2 = geradorDeHorarioAleatorio(minimo, maximo)
print(horario1) --> 21/07/2026 00:40:30 (varia)
print(horario2) --> 19/07/2026 20:12:25 (varia)

-- propriedade: o formato é sempre dd/mm/aaaa hh:mm:ss
local formatoEsperado = "^%d%d/%d%d/%d%d%d%d %d%d:%d%d:%d%d$"
assert(horario1:match(formatoEsperado))
assert(horario2:match(formatoEsperado))

--------------------------------------------------------------------------------
