-- buracos_e_comprimento.lua

-- O operador # devolve uma FRONTEIRA: um índice n tal que t[n] ~= nil e
-- t[n + 1] == nil. Em uma sequência (sem buracos) isso é o comprimento.
-- Com buracos (nil no meio), qualquer fronteira é resposta válida — o
-- valor depende da representação interna e NÃO é confiável.

--------------------------------------------------------------------------------
-- #1. Em sequências, # é o comprimento:

local frutas = { "maçã", "banana", "cereja" }
assert(#frutas == 3)

--------------------------------------------------------------------------------
-- #2. t[i] = nil abre um buraco — e # deixa de ser confiável:

local numeros = { 10, 20, 30, 40 }
numeros[3] = nil -- agora a "lista" é {10, 20, nil, 40}

-- 4 e 2 são fronteiras válidas para esta tabela; qual delas # devolve é
-- detalhe interno. Não escreva código que dependa desse valor:
local fronteira = #numeros
assert(fronteira == 4 or fronteira == 2)

--------------------------------------------------------------------------------
-- #3. Para REMOVER de uma sequência, use table.remove, que desloca os
-- elementos seguintes e preserva a forma de sequência:

local cores = { "azul", "verde", "vermelho" }
table.remove(cores, 2) -- remove "verde" e puxa "vermelho" para o índice 2
assert(#cores == 2 and cores[2] == "vermelho")

-- compare com a atribuição de nil, que NÃO desloca nada:
local tons = { "claro", "médio", "escuro" }
tons[2] = nil
assert(tons[3] == "escuro") -- o buraco fica no meio

-- e ipairs para no primeiro buraco:
local visitados = 0
for _ in ipairs(tons) do visitados = visitados + 1 end
assert(visitados == 1)

--------------------------------------------------------------------------------
-- #4. Arrays esparsos: mantenha a contagem você mesmo (ou use pairs).

local esparso = {}
esparso[1] = "a"
esparso[1000] = "b" -- tudo entre 2 e 999 é nil

local total = 0
for _ in pairs(esparso) do total = total + 1 end
assert(total == 2) -- pairs visita só as chaves existentes

-- Quando a contagem importa e pode haver nil, o idioma é o campo n
-- (o mesmo que table.pack usa — veja funcoes/multiplos_retornos.lua):
local registro = { n = 0 }
local function adicionar(valor)
  registro.n = registro.n + 1
  registro[registro.n] = valor
end
adicionar("x"); adicionar(nil); adicionar("z")
assert(registro.n == 3)

print("Buracos e comprimento: as regras do # foram verificadas!")
