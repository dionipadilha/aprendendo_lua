-- agendador.lua

-- Agendador cooperativo round-robin (PiL 9.4): várias tarefas se
-- revezam em UMA única thread. Cada tarefa é uma corrotina na fila;
-- coroutine.yield() significa "passo a vez", e o agendador retoma a
-- próxima da fila até todas morrerem.
--
-- Nota honesta: isto é concorrência COOPERATIVA, sem paralelismo — se
-- uma tarefa nunca cede, as outras nunca rodam; e nada aqui torna I/O
-- "assíncrono" sozinho. Para intercalar I/O de verdade seria preciso um
-- hospedeiro que integre as corrotinas a um laço de eventos (LuaSocket/
-- Copas, OpenResty, ou o programa C que embute Lua).
-- Estados e ciclo de vida: ver ciclo_de_vida_das_corrotinas.lua.

local agendador = { fila = {} }

function agendador.adicionar(funcao)
  table.insert(agendador.fila, coroutine.create(funcao))
end

-- O laço do agendador: retoma a tarefa da frente da fila; quem cede
-- volta para o FIM (round-robin), quem termina ou falha sai dela.
function agendador.executar()
  local falhas = {}
  while #agendador.fila > 0 do
    local tarefa = table.remove(agendador.fila, 1)
    local sucesso, mensagem = coroutine.resume(tarefa)
    if not sucesso then
      -- Uma tarefa que estoura NÃO derruba o agendador: o erro chega
      -- aqui como retorno de resume (false + mensagem) — a mesma dupla
      -- que ciclo_de_vida_das_corrotinas.lua passa ao assert. Lá a
      -- falha deve abortar; aqui ela vira registro e a fila continua.
      table.insert(falhas, mensagem)
    elseif coroutine.status(tarefa) == "suspended" then
      table.insert(agendador.fila, tarefa)
    end
    -- ("dead" com sucesso = tarefa concluída; simplesmente sai da fila)
  end
  return falhas
end

--------------------------------------------------------------------------------
-- #1. Três tarefas determinísticas intercalando trabalho (sem tempo nem
-- sorteio: contadores). Cada tarefa registra seus passos em `ordem` e
-- cede a vez entre um passo e outro.

local ordem = {}

local function criarTarefa(nome, passos)
  return function()
    for passo = 1, passos do
      table.insert(ordem, nome .. passo)
      if passo < passos then
        coroutine.yield() -- "passo a vez", sem transportar valores
      end
    end
  end
end

agendador.adicionar(criarTarefa("a", 3))
agendador.adicionar(criarTarefa("b", 2))
agendador.adicionar(criarTarefa("c", 3))

local falhas = agendador.executar()
assert(#falhas == 0)

-- A intercalação EXATA do round-robin: a-b-c, a-b-c... até "b" (a mais
-- curta) morrer no seu 2º passo; daí em diante só "a" e "c" alternam.
print(table.concat(ordem, " ")) --> a1 b1 c1 a2 b2 c2 a3 c3
assert(table.concat(ordem, " ") == "a1 b1 c1 a2 b2 c2 a3 c3")

--------------------------------------------------------------------------------
-- #2. Falha isolada: a tarefa "x" estoura no seu segundo turno, e ainda
-- assim "a" completa os três passos — a falha vira registro, não
-- catástrofe.

ordem = {}
agendador.adicionar(criarTarefa("a", 3))
agendador.adicionar(function()
  table.insert(ordem, "x1")
  coroutine.yield()
  error("falha proposital na tarefa x")
end)

falhas = agendador.executar()

-- a3 aconteceu DEPOIS do estouro de "x" — o agendador sobreviveu:
print(table.concat(ordem, " ")) --> a1 x1 a2 a3
assert(table.concat(ordem, " ") == "a1 x1 a2 a3")

-- A mensagem capturada vem com o prefixo "arquivo:linha:" que error()
-- acrescenta (como em ../erros/erro.lua); o padrão com %d+ evita
-- amarrar o teste a um número de linha:
assert(#falhas == 1)
assert(falhas[1]:match("^agendador%.lua:%d+: falha proposital na tarefa x$"))

print("agendador round-robin verificado!")
