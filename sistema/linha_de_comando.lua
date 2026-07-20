-- linha_de_comando.lua

-- Lua como linguagem de scripts de linha de comando: a tabela arg, códigos
-- de saída (os.exit), variáveis de ambiente (os.getenv) e os três canais
-- padrão (stdin, stdout, stderr). Este arquivo roda em dois modos:
--   * SEM argumentos (como na suíte de testes): faz todas as verificações;
--   * COM argumentos ("subchamada"): só imprime o que recebeu e sai — é
--     assim que o modo principal testa a passagem de argumentos chamando a
--     si mesmo, sem risco de recursão infinita.

--------------------------------------------------------------------------------
-- #1: a tabela arg

-- O interpretador de linha de comando monta a tabela global arg:
--   arg[0]        → o nome do script;
--   arg[1..n]     → os argumentos passados depois do script;
--   índices < 0   → o interpretador e suas opções (ex.: arg[-1] = "lua5.4").

assert(type(arg) == "table")
assert(arg[0]:match("linha_de_comando%.lua$"))

-- o índice MAIS negativo é o próprio interpretador — achá-lo por busca
-- funciona mesmo com opções no meio (ex.: lua5.4 -W script.lua):
local indice = 0
while arg[indice - 1] ~= nil do indice = indice - 1 end
local interpretador = arg[indice]
assert(type(interpretador) == "string")

-- Modo "subchamada": com argumentos, imprime e SAI (nada de recursão).
if arg[1] ~= nil then
  io.stderr:write("diagnóstico: rodando como subchamada\n") -- NÃO vai ao stdout
  print(("recebi %d argumentos: %s"):format(#arg, table.concat(arg, " ")))
  os.exit(0)
end

-- Modo principal: a suíte executa sem argumentos, então arg[1] é nil.
assert(arg[1] == nil)

--------------------------------------------------------------------------------
-- #2: argumentos de verdade — o script chama a si mesmo

-- io.popen roda um comando CAPTURANDO seu stdout (os.execute só devolve o
-- status). Reutilizamos interpretador e arg[0] para o comando funcionar em
-- qualquer instalação (na CI de Windows o binário chama-se só "lua").

local comando = ("%s %s teste 123"):format(interpretador, arg[0])
local processo = assert(io.popen(comando))
local saida = processo:read("a")
processo:close()

-- só o stdout da subchamada chegou aqui — a linha de diagnóstico que ela
-- escreveu no stderr NÃO aparece (é a lição do #5, provada na prática):
assert(saida == "recebi 2 argumentos: teste 123\n")
print("subchamada respondeu: " .. saida:gsub("\n$", ""))
--> subchamada respondeu: recebi 2 argumentos: teste 123

--------------------------------------------------------------------------------
-- #3: os.exit e códigos de saída

-- os.exit(codigo) encerra o processo; o código vai para quem chamou
-- (0 = sucesso, qualquer outro = falha — a convenção universal do shell).
-- os.execute devolve o trio (sucesso, "exit"|"signal", código):

local sucesso, tipoDeTermino, codigo = os.execute(interpretador .. ' -e "os.exit(3)"')
assert(sucesso == nil)          -- código diferente de zero → falha (nil)
assert(tipoDeTermino == "exit") -- terminou por saída normal, não por sinal
assert(codigo == 3)             -- o código atravessou intacto até o pai
print("o filho saiu com código " .. codigo)
--> o filho saiu com código 3

-- os.exit também aceita booleano: true → sucesso, false → falha (portátil,
-- sem número mágico). A subchamada do #1 usou os.exit(0); o fim deste
-- arquivo usa os.exit(true).
local sucessoVerdadeiro, _, codigoVerdadeiro = os.execute(interpretador .. ' -e "os.exit(true)"')
assert(sucessoVerdadeiro == true and codigoVerdadeiro == 0)

--------------------------------------------------------------------------------
-- #4: os.getenv — variáveis de ambiente

-- Configuração que o sistema passa ao processo. PATH existe em qualquer
-- plataforma (é como o shell encontra os executáveis):
local caminho = os.getenv("PATH")
assert(type(caminho) == "string" and #caminho > 0)

-- variável inexistente devolve nil — nunca lança erro:
assert(os.getenv("VARIAVEL_QUE_NAO_EXISTE_9f3a") == nil)

--------------------------------------------------------------------------------
-- #5: stderr e stdin

-- Por que io.stderr:write em vez de print? Pipes capturam o STDOUT: em
-- `lua script.lua | outro`, tudo que o print emite vira entrada do outro
-- programa. Erros e avisos no stdout contaminariam esses dados; no stderr,
-- continuam visíveis no terminal sem entrar no pipe — foi o que o #2
-- provou: o diagnóstico da subchamada não apareceu na saída capturada.
io.stderr:write("aviso: esta linha não entra em pipes nem no io.popen\n")

-- stdin: io.read() lê uma linha (e devolve nil no fim da entrada). A suíte
-- roda os exemplos com a entrada vazia (</dev/null), então io.read() devolve
-- nil imediatamente; num terminal interativo, esperaria você digitar.
local linha = io.read()
if linha == nil then
  print("stdin vazio: nenhuma linha para ler")
else
  print("stdin trouxe: " .. linha)
end
--> stdin vazio: nenhuma linha para ler    (com a entrada vazia)

-- io.lines() itera o RESTANTE do stdin linha a linha (aqui, zero linhas):
local linhasRestantes = 0
for _ in io.lines() do linhasRestantes = linhasRestantes + 1 end
print("linhas restantes no stdin: " .. linhasRestantes)
--> linhas restantes no stdin: 0           (com a entrada vazia)

print("linha de comando: arg, os.exit, os.getenv e canais verificados!")
os.exit(true) -- encerra explicitamente com sucesso (equivale a os.exit(0))
