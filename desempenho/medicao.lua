-- medicao.lua

-- Desempenho se MEDE, não se afirma. Este arquivo cronometra dois idiomas
-- clássicos de otimização em Lua e imprime os números — mas os asserts só
-- verificam que as duas versões produzem o MESMO resultado. Tempo absoluto
-- varia por máquina, carga e versão: um assert sobre tempo passaria aqui e
-- falharia no computador de outra pessoa (teste "flaky"). Daí a regra:
-- assert no resultado, print no tempo.
--
-- os.clock mede tempo de CPU — a medida certa para benchmark, porque não
-- conta as esperas do sistema (ver ../sistema/cpu_vs_parede.lua).

local function cronometrar(rotulo, funcao)
  local inicio = os.clock()
  local resultado = funcao()
  local duracao = os.clock() - inicio
  print(("%-36s %6.3f s"):format(rotulo, duracao))
  return resultado, duracao
end

--------------------------------------------------------------------------------
-- #1: concatenação em laço vs table.concat

-- Strings de Lua são imutáveis: s = s .. x cria uma string NOVA a cada
-- volta, copiando tudo o que já existia — custo total quadrático.
-- table.concat junta os pedaços de uma vez só, no final — custo linear.

local QUANTIDADE = 100000
local pedacos = {}
for i = 1, QUANTIDADE do
  pedacos[i] = tostring(i % 10)
end

local textoDoLaco = cronometrar("concatenação em laço (s = s .. x)", function()
  local s = ""
  for i = 1, QUANTIDADE do
    s = s .. pedacos[i]
  end
  return s
end)
--> concatenação em laço (s = s .. x)   0.253 s   (o tempo varia por máquina)

local textoDoConcat = cronometrar("table.concat(pedacos)", function()
  return table.concat(pedacos)
end)
--> table.concat(pedacos)               0.002 s   (o tempo varia por máquina)

-- o assert verifica a IGUALDADE dos resultados — nunca os tempos:
assert(textoDoLaco == textoDoConcat)
assert(#textoDoConcat == QUANTIDADE)

--------------------------------------------------------------------------------
-- #2: acesso global vs local em laço quente

-- Cada math.floor no laço custa duas buscas em tabela por volta (_ENV.math
-- e depois math.floor); a cópia local é um registro da máquina virtual.
-- A diferença só aparece em laços quentes — por isso "torne locais as
-- variáveis usadas em laços" é o conselho nº 1 de otimização em Lua
-- (documentacao/guia_de_estudos.md, seção 11).

local VOLTAS = 5000000

local somaComGlobal = cronometrar("math.floor global no laço", function()
  local soma = 0
  for i = 1, VOLTAS do
    soma = soma + math.floor(i / 3) - math.floor(i / 7)
  end
  return soma
end)
--> math.floor global no laço           0.520 s   (o tempo varia por máquina)

local somaComLocal = cronometrar("local floor = math.floor", function()
  local floor = math.floor
  local soma = 0
  for i = 1, VOLTAS do
    soma = soma + floor(i / 3) - floor(i / 7)
  end
  return soma
end)
--> local floor = math.floor            0.330 s   (o tempo varia por máquina)

assert(somaComGlobal == somaComLocal) -- de novo: igualdade, não tempo

--------------------------------------------------------------------------------
-- A lição honesta: os números acima mudam a cada máquina — e um pouco a
-- cada execução. O que se transfere é a ORDEM: quadrático perde de linear
-- em qualquer hardware, e menos buscas por volta nunca é mais lento.
-- Meça no SEU caso antes de otimizar; troque a versão clara pela "rápida"
-- só quando a medição apontar que ali mora um gargalo.

print("medição concluída: resultados idênticos; os tempos são informativos.")
