-- multiplos_retornos.lua

-- Regras de AJUSTE de múltiplos retornos: uma chamada só conserva todos
-- os seus retornos quando é o ÚLTIMO elemento de uma lista de
-- expressões; em qualquer outra posição ela é ajustada para UM valor.
-- É a pegadinha mais comum de funções em Lua.

local function doisValores()
  return "a", "b"
end

--------------------------------------------------------------------------------
-- #1. Na última posição, todos os retornos entram na lista:

local x, y = doisValores()
assert(x == "a" and y == "b")

local lista = { doisValores() }
assert(#lista == 2)

--------------------------------------------------------------------------------
-- #2. No MEIO da lista, a chamada é truncada para um valor:

local truncada = { doisValores(), "z" }
assert(#truncada == 2 and truncada[1] == "a" and truncada[2] == "z") -- o "b" sumiu

-- (o luacheck é silenciado porque `terceiro` ficar sem valor É a demonstração)
local primeiro, segundo, terceiro = doisValores(), "z" -- luacheck: ignore 221
assert(primeiro == "a" and segundo == "z" and terceiro == nil)

--------------------------------------------------------------------------------
-- #3. Parênteses truncam para EXATAMENTE um valor — mesmo na última posição:

local soUm = { (doisValores()) }
assert(#soUm == 1 and soUm[1] == "a")

--------------------------------------------------------------------------------
-- #4. Com nil no meio dos varargs, conte com select("#", ...) — nunca
-- com # (que é fronteira; veja tabelas/buracos_e_comprimento.lua):

local function contar(...)
  return select("#", ...)
end
assert(contar(1, nil, 3) == 3)
assert(contar() == 0)

-- table.pack guarda essa contagem no campo n:
local pacote = table.pack(1, nil, 3)
assert(pacote.n == 3 and pacote[3] == 3)

-- e table.unpack com os limites 1..n restaura inclusive os nils do meio:
local a, b, c = table.unpack(pacote, 1, pacote.n)
assert(a == 1 and b == nil and c == 3)

--------------------------------------------------------------------------------
-- #5. Lua GARANTE a eliminação de chamadas de cauda: `return f(x)` não
-- empilha quadro novo, então a recursão abaixo não estoura a pilha nem
-- com um milhão de níveis.

local function contagemRegressiva(n)
  if n == 0 then return "fim" end
  return contagemRegressiva(n - 1) -- chamada de cauda própria
end

assert(contagemRegressiva(1000000) == "fim")

-- atenção: `return (f(x))` e `return f(x) + 0` NÃO são chamadas de
-- cauda — qualquer trabalho após a chamada exige manter o quadro.

print("Regras de ajuste de múltiplos retornos verificadas!")
