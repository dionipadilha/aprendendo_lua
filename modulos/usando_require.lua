-- usando_require.lua

-- require procura o módulo em package.path, executa o arquivo UMA vez
-- e guarda o valor devolvido em package.loaded; os requires seguintes
-- devolvem esse valor em cache, sem reexecutar nada.
-- (execute a partir deste diretório: o "./?.lua" de package.path
-- encontra modulo.lua aqui ao lado)

local modulo = require "modulo"

assert(modulo.saudar("mundo") == "Olá, mundo!")
assert(modulo.dobrar(4) == 8)

--------------------------------------------------------------------------------
-- O cache: um segundo require devolve a MESMA tabela...

local outraVez = require "modulo"
assert(outraVez == modulo)

-- ...porque o valor ficou guardado em package.loaded:
assert(package.loaded["modulo"] == modulo)

-- o estado interno também prova que o arquivo não reexecutou:
-- o autoteste do módulo saudou 1 vez, e nós saudamos mais 1 acima.
assert(modulo.totalDeSaudacoes() == 2)

--------------------------------------------------------------------------------
-- Apagar a entrada do cache força a reexecução no próximo require:

package.loaded["modulo"] = nil
local recarregado = require "modulo"
assert(recarregado ~= modulo)              -- tabela nova, arquivo reexecutado
assert(recarregado.totalDeSaudacoes() == 1) -- estado interno zerado (só o autoteste)

print("require, cache e package.loaded verificados!")
