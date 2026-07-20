-- introspeccao.lua

-- A biblioteca debug abre a caixa-preta do interpretador: inspeciona a
-- pilha de chamadas, as locais e as upvalues de qualquer função. Ela existe
-- para DEPURADORES e ferramentas (profilers, cobertura) — não para a lógica
-- do programa: é lenta e fura o encapsulamento de propósito.

--------------------------------------------------------------------------------
-- #1: debug.getinfo — quem sou eu, onde estou

-- getinfo(nivel, filtro): nível 1 = a função que chama getinfo; o filtro
-- pede só os campos necessários ("n" nome, "S" origem, "l" linha atual).

local function ondeEstou()
  return debug.getinfo(1, "nSl")
end

local info = ondeEstou()
assert(info.what == "Lua")                         -- função escrita em Lua
assert(info.short_src:match("introspeccao%.lua$")) -- o arquivo onde ela vive
assert(info.name == "ondeEstou")                   -- o nome que o CHAMADOR usa
assert(info.namewhat == "local")                   -- ...e a conhece como local
assert(info.currentline > 0)
print(("estou em %s, linha %d"):format(info.short_src, info.currentline))
--> estou em introspeccao.lua, linha NN

-- currentline é a linha EM EXECUÇÃO: duas chamadas em linhas consecutivas
-- devolvem números consecutivos (o assert verifica a RELAÇÃO, não um número
-- fixo — assim o teste sobrevive a edições do arquivo).
local function linhaDoChamador() return debug.getinfo(2, "l").currentline end
local primeira = linhaDoChamador()
local segunda = linhaDoChamador()
assert(segunda == primeira + 1)

-- getinfo também aceita uma FUNÇÃO no lugar do nível. Funções de biblioteca
-- são escritas em C: não têm fonte Lua nem número de linha.
local infoDoPrint = debug.getinfo(print, "S")
assert(infoDoPrint.what == "C")
assert(infoDoPrint.short_src == "[C]")
assert(infoDoPrint.linedefined == -1)

--------------------------------------------------------------------------------
-- #2: debug.getlocal e setlocal — ler (e ALTERAR) locais de outro quadro

-- getlocal(nivel, indice) lê a local nº indice de um quadro da pilha;
-- setlocal escreve nela. É assim que um depurador implementa "inspecionar
-- variável" e "corrigir valor no breakpoint" sem nenhuma cooperação da
-- função observada — a razão de essa porta existir.

local function espiar()
  return debug.getlocal(2, 1) -- nível 2 = quem chamou espiar
end

local function corrigir(valorNovo)
  return debug.setlocal(2, 1, valorNovo)
end

local function paciente()
  local diagnostico = "provisorio" -- a local nº 1 deste quadro
  local nome, valor = espiar()
  assert(nome == "diagnostico" and valor == "provisorio")
  local nomeAlterado = corrigir("definitivo")
  assert(nomeAlterado == "diagnostico")
  -- a local mudou POR FORA, sem nenhuma atribuição aqui dentro:
  assert(diagnostico == "definitivo")
  return diagnostico
end

assert(paciente() == "definitivo")
print("setlocal alterou uma local do chamador (poder de depurador)")

-- Custo e fragilidade: o índice depende da ORDEM de declaração (declarar
-- outra local antes de diagnostico quebraria os índices acima) e cada
-- acesso é caro. Ferramenta de depuração — nunca API entre funções.

--------------------------------------------------------------------------------
-- #3: debug.getupvalue e setupvalue — o estado privado das clausuras

-- Clausuras guardam estado em upvalues (../funcoes/clausuras.lua). O código
-- comum não tem como tocá-las de fora — a biblioteca debug tem.

local function novoContador()
  local total = 0
  return function()
    total = total + 1
    return total
  end
end

local contar = novoContador()
contar()
contar()

-- a upvalue nº 1 da clausura é total (a única variável externa que ela usa):
local nomeDaUpvalue, valorDaUpvalue = debug.getupvalue(contar, 1)
assert(nomeDaUpvalue == "total" and valorDaUpvalue == 2)

debug.setupvalue(contar, 1, 100)
assert(contar() == 101) -- o contador seguiu de onde o setupvalue o deixou
print("upvalue 'total' espiada e alterada: privacidade em Lua é convenção")

--------------------------------------------------------------------------------
-- debug.traceback (a pilha inteira como texto) já trabalha em
-- ../erros/objetos_de_erro.lua (#3: xpcall + debug.traceback): o tratador
-- do xpcall roda ANTES de a pilha ser desfeita — o único momento em que o
-- traceback completo existe. Os ganchos de execução ficam em gancho.lua.
