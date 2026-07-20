-- modos_do_coletor.lua

-- collectgarbage aceita opções que controlam o coletor de lixo de Lua 5.4:
--   "incremental"  - ativa o modo incremental (coleta em pequenos passos).
--   "generational" - ativa o modo geracional (foca nos objetos jovens;
--                    é o modo em que o interpretador de linha de comando
--                    `lua` inicia — um estado Lua embutido em C via
--                    liblua, porém, começa no modo incremental).
--   "count"        - memória em uso pelo Lua, em kilobytes.
--   "collect"      - executa um ciclo completo de coleta (opção padrão).

--------------------------------------------------------------------------------
-- #1. Trocando o modo do coletor: a chamada retorna o modo ANTERIOR.

local modoAnterior = collectgarbage("incremental")
print("modo anterior:", modoAnterior) --> generational
assert(modoAnterior == "generational")

-- Voltando ao modo geracional; agora o modo anterior é "incremental":
modoAnterior = collectgarbage("generational")
assert(modoAnterior == "incremental")

--------------------------------------------------------------------------------
-- #2. "count": mede a memória em uso (valor volátil; verificamos propriedades).

local memoriaInicialEmKb = collectgarbage("count")
print(("memória em uso: %.1f KB"):format(memoriaInicialEmKb))
assert(type(memoriaInicialEmKb) == "number" and memoriaInicialEmKb > 0)

-- Alocar objetos aumenta a contagem (a lista existe só para ocupar memória):
local listaGrande = {} -- luacheck: ignore 241
for i = 1, 10000 do listaGrande[i] = { i } end
local memoriaComLista = collectgarbage("count")
assert(memoriaComLista > memoriaInicialEmKb)

-- Liberar a referência e coletar reduz a contagem:
listaGrande = nil
collectgarbage("collect")
assert(collectgarbage("count") < memoriaComLista)

--------------------------------------------------------------------------------
-- #3. __mode = "v": VALORES fracos (chaves fracas estão em chaves_fracas.lua).

local valoresFracos = setmetatable({}, { __mode = "v" })

-- valor sem nenhuma outra referência forte: será coletado
valoresFracos["temporaria"] = { dado = "descartável" }

-- valor com referência forte externa: sobrevive à coleta
local valorVivo = { dado = "permanente" }
valoresFracos["permanente"] = valorVivo

collectgarbage("collect")
assert(valoresFracos["temporaria"] == nil)
assert(valoresFracos["permanente"] == valorVivo)
print('__mode = "v": só o valor sem referência forte foi coletado')

--------------------------------------------------------------------------------
-- #4. __mode = "kv": tabela totalmente fraca.
-- A entrada é removida se a CHAVE ou o VALOR for coletado.

local tudoFraco = setmetatable({}, { __mode = "kv" })

local chaveViva = {}
tudoFraco[chaveViva] = { "valor sem outra referência" } -- valor será coletado
tudoFraco[{}] = { "par sem nenhuma referência" }        -- chave e valor coletados

collectgarbage("collect")

local entradasRestantes = 0
for _ in pairs(tudoFraco) do entradasRestantes = entradasRestantes + 1 end
assert(entradasRestantes == 0) -- em cada par, chave OU valor foi coletado
print('__mode = "kv": todas as entradas foram removidas')

--------------------------------------------------------------------------------
