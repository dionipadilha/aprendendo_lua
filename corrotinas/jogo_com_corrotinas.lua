-- jogo_com_corrotinas.lua

-- Mini-jogo de perseguição numa grade: a corrotina do jogador espera
-- comandos (w/a/s/d) e a dos inimigos persegue o jogador um passo por
-- turno. O ponto didático é a troca de valores com resume/yield: o
-- PRIMEIRO resume entrega os personagens (viram os parâmetros da
-- função); os seguintes entregam o comando do turno (viram o retorno
-- do yield) — ver argumentos_de_corrotinas.lua.

--------------------------------------------------------------------------------
-- Passo #1: Define a grade do jogo e as funções utilitárias:

local tamanhoDaGrade = 5

local function criarGrade(tamanho)
  local grade = {}
  for i = 1, tamanho do
    grade[i] = {}
    for j = 1, tamanho do
      grade[i][j] = '.'
    end
  end
  return grade
end

local function imprimirGrade(grade)
  for i = 1, #grade do
    for j = 1, #grade[i] do
      io.write(grade[i][j] .. ' ')
    end
    print()
  end
end

local function limparGrade(grade)
  for i = 1, #grade do
    for j = 1, #grade[i] do
      grade[i][j] = '.'
    end
  end
end

--------------------------------------------------------------------------------
-- Passo #2: Define a corrotina do jogador:

local function moverJogador(jogador)
  while true do
    local movimento = coroutine.yield()
    if movimento == 'w' and jogador.x > 1 then
      jogador.x = jogador.x - 1
    elseif movimento == 's' and jogador.x < tamanhoDaGrade then
      jogador.x = jogador.x + 1
    elseif movimento == 'a' and jogador.y > 1 then
      jogador.y = jogador.y - 1
    elseif movimento == 'd' and jogador.y < tamanhoDaGrade then
      jogador.y = jogador.y + 1
    end
  end
end

--------------------------------------------------------------------------------
-- Passo #3: Define a corrotina dos inimigos (um passo em direção ao
-- jogador por turno):

local function moverInimigos(inimigos, jogador)
  while true do
    for _, inimigo in ipairs(inimigos) do
      if inimigo.x < jogador.x then
        inimigo.x = inimigo.x + 1
      elseif inimigo.x > jogador.x then
        inimigo.x = inimigo.x - 1
      end
      if inimigo.y < jogador.y then
        inimigo.y = inimigo.y + 1
      elseif inimigo.y > jogador.y then
        inimigo.y = inimigo.y - 1
      end
    end
    coroutine.yield()
  end
end

--------------------------------------------------------------------------------
-- Passo #4: Inicializa o estado do jogo e as corrotinas:

local jogador = { x = 1, y = 1 }
local inimigos = {
  { x = 5, y = 5 },
  { x = 5, y = 1 }
}
local grade = criarGrade(tamanhoDaGrade)

local corrotinaDoJogador = coroutine.create(moverJogador)
local corrotinaDosInimigos = coroutine.create(moverInimigos)

-- primeiro resume: entrega os personagens e roda até o primeiro yield
coroutine.resume(corrotinaDoJogador, jogador)
coroutine.resume(corrotinaDosInimigos, inimigos, jogador)

local function atualizarGrade()
  limparGrade(grade)
  grade[jogador.x][jogador.y] = 'J'
  for _, inimigo in ipairs(inimigos) do
    grade[inimigo.x][inimigo.y] = 'I'
  end
end

--------------------------------------------------------------------------------
-- Passo #5: Executa o jogo:

print("Mova com w/a/s/d (+ Enter); 'q' ou fim da entrada encerra.")

local fimDeJogo = false
while not fimDeJogo do
  atualizarGrade()
  imprimirGrade(grade)

  local movimento = io.read()
  if movimento == nil or movimento == 'q' then
    print("Jogo encerrado.")
    break
  end

  coroutine.resume(corrotinaDoJogador, movimento)
  coroutine.resume(corrotinaDosInimigos)

  -- Verifica a condição de fim de jogo:
  for _, inimigo in ipairs(inimigos) do
    if inimigo.x == jogador.x and inimigo.y == jogador.y then
      print("Fim de jogo! Os inimigos pegaram você!")
      fimDeJogo = true
      break
    end
  end
end

--------------------------------------------------------------------------------
