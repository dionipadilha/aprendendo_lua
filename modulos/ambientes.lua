-- ambientes.lua

-- Em Lua, "variável global" é açúcar sintático: todo nome que não é local
-- compila para _ENV.nome, onde _ENV é uma upvalue que normalmente aponta
-- para a tabela global _G. Trocar o _ENV troca o mundo que o código enxerga
-- — a base dos sandboxes no caso emblemático de Lua: embutida em outro
-- programa (jogo, servidor, editor), rodando código alheio com poderes
-- limitados.

-- No nível principal, o _ENV padrão é a própria tabela global:
assert(_ENV == _G)

-- ler um "global" é ler um campo de _ENV — print e _ENV.print são o mesmo valor:
assert(print == _ENV.print)

--------------------------------------------------------------------------------
-- #1: local _ENV = ... troca o ambiente de um escopo inteiro

-- Dentro de demonstrar, TODO nome não local passa a ser campo da tabela nova.
-- (o luacheck não acompanha a troca de _ENV e enxergaria x como um global de
-- verdade — daí os dois "ignore" pontuais, justificados aqui)

local function demonstrar()
  local _ENV = { print = print } -- ambiente novo: só conhece print
  -- a atribuição abaixo equivale a _ENV.x = 1 — nada toca a tabela _G:
  x = 1 -- luacheck: ignore 111
  print("dentro do ambiente próprio, x = " .. x) -- luacheck: ignore 113
  return _ENV
end

local ambiente = demonstrar()
--> dentro do ambiente próprio, x = 1

assert(ambiente.x == 1) -- o "global" x foi parar na tabela do ambiente...
assert(_G.x == nil)     -- ...e a tabela global de verdade ficou intacta

--------------------------------------------------------------------------------
-- #2: load com os 4 argumentos — um trecho não confiável num sandbox

-- load(trecho, nome, modo, ambiente):
--   trecho   → string com o código-fonte (ou função que o produz aos pedaços);
--   nome     → aparece nas mensagens de erro ("=nome" mostra o nome puro);
--   modo     → "t" só texto, "b" só binário, "bt" ambos (o perigoso padrão);
--   ambiente → o _ENV do código carregado.

local caixaDeAreia = { print = print, math = math } -- whitelist: nada de os/io

local trecho = [[
  resultado = math.floor(7.9) -- "global" do trecho: cai na caixa de areia
  return os, io               -- o que o trecho enxerga dos módulos perigosos
]]

local confinado = assert(load(trecho, "=trecho-confinado", "t", caixaDeAreia))
local osVisto, ioVisto = confinado()

assert(osVisto == nil and ioVisto == nil) -- o sandbox NÃO enxerga os nem io
assert(caixaDeAreia.resultado == 7)       -- a escrita ficou confinada à caixa
assert(_G.resultado == nil)               -- nada vazou para o hospedeiro
print("sandbox: os =", osVisto, "| io =", ioVisto, "| resultado =", caixaDeAreia.resultado)
--> sandbox: os = nil | io = nil | resultado = 7

-- o nome "=..." dado ao load identifica o trecho nas mensagens de erro:
local falho = assert(load("naoExiste()", "=codigo-do-cliente", "t", caixaDeAreia))
local ok, mensagem = pcall(falho)
assert(not ok)
assert(mensagem:match("^codigo%-do%-cliente:1: attempt to call a nil value"))

--------------------------------------------------------------------------------
-- #3: modo "t" — a barreira contra bytecode precompilado

-- string.dump devolve o BYTECODE de uma função: o formato binário interno
-- que o interpretador executa direto, sem compilar.

local function quadrado(n) return n * n end
local binario = string.dump(quadrado)
assert(binario:byte(1) == 27) -- 1º byte é ESC (27): a marca de chunk binário

-- modo "b" aceita o binário, e a função carregada funciona:
local doBinario = assert(load(binario, "=quadrado", "b"))
assert(doBinario(5) == 25)

-- perigo: o modo PADRÃO é "bt" — um load ingênuo também aceita binário:
assert(load(binario) ~= nil)

-- modo "t" recusa: load devolve nil + mensagem, e o assert a transforma em
-- erro para o pcall (ganhando o prefixo arquivo:linha — ver ../erros/assercao.lua):
local recusou, mensagemDoModoT = pcall(function()
  return assert(load(binario, "=quadrado", "t", caixaDeAreia))
end)
assert(not recusou)
assert(mensagemDoModoT:match("attempt to load a binary chunk"))
print("modo \"t\" recusou o binário: " .. mensagemDoModoT)
--> modo "t" recusou o binário: ambientes.lua:NN: attempt to load a binary chunk (mode is 't')

-- Por que isso importa: Lua NÃO valida bytecode ao carregar (o verificador
-- foi removido por ser contornável). Bytecode malicioso pode corromper o
-- interpretador por dentro e escapar de QUALQUER sandbox de ambiente — por
-- isso todo load de código não confiável deve exigir o modo "t".

--------------------------------------------------------------------------------
-- #4: limitações honestas do sandbox de ambiente

-- Trocar o _ENV controla O QUE o código enxerga, não QUANTO ele consome:
-- `while true do end` roda para sempre sem tocar em global nenhum, e criar
-- strings gigantes consome memória sem pedir licença. Contra laço infinito,
-- a mitigação é um gancho de contagem de instruções (debug.sethook) — veja
-- ../depuracao/gancho.lua, que reaproveita exatamente este sandbox.

local lacoInfinito = assert(load("while true do end", "=laco", "t", caixaDeAreia))
assert(type(lacoInfinito) == "function") -- carregar é inofensivo; EXECUTAR é o risco

print("ambientes: _ENV, sandbox com load e modo \"t\" verificados!")
