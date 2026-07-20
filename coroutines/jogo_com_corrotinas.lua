-- jogo_com_corrotinas.lua

--------------------------------------------------------------------------------
-- Passo #1: Define a grade do jogo e as funções utilitárias:

local tamanho_da_grade = 5

local function criar_grade(tamanho)
  local grade = {}
  for i = 1, tamanho do
    grade[i] = {}
    for j = 1, tamanho do
      grade[i][j] = '.'
    end
  end
  return grade
end

local function imprimir_grade(grade)
  for i = 1, #grade do
    for j = 1, #grade[i] do
      io.write(grade[i][j] .. ' ')
    end
    print()
  end
end

local function limpar_grade(grade)
  for i = 1, #grade do
    for j = 1, #grade[i] do
      grade[i][j] = '.'
    end
  end
end

--------------------------------------------------------------------------------
-- Passo #2:  Define a corrotina do jogador:

local jogador = { x = 1, y = 1 }

local function mover_jogador(grade, jogador)
  while true do
    local movimento = coroutine.yield()
    if movimento == 'w' and jogador.x > 1 then
      jogador.x = jogador.x - 1
    elseif movimento == 's' and jogador.x < tamanho_da_grade then
      jogador.x = jogador.x + 1
    elseif movimento == 'a' and jogador.y > 1 then
      jogador.y = jogador.y - 1
    elseif movimento == 'd' and jogador.y < tamanho_da_grade then
      jogador.y = jogador.y + 1
    end
  end
end

--------------------------------------------------------------------------------
-- Passo #3:  Define a corrotina dos inimigos:

local inimigos = {
  { x = 5, y = 5 },
  { x = 5, y = 1 }
}
local function mover_inimigos(grade, inimigos, jogador)
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
-- Passo #4:  Inicializa as corrotinas e o laço principal do jogo:

local corrotina_do_jogador = coroutine.create(mover_jogador)
local corrotina_dos_inimigos = coroutine.create(mover_inimigos)

coroutine.resume(corrotina_do_jogador, criar_grade(tamanho_da_grade), jogador)
coroutine.resume(corrotina_dos_inimigos, criar_grade(tamanho_da_grade), inimigos, jogador)

local function atualizar_grade(grade, jogador, inimigos)
  limpar_grade(grade)
  grade[jogador.x][jogador.y] = 'J'
  for _, inimigo in ipairs(inimigos) do
    grade[inimigo.x][inimigo.y] = 'I'
  end
end

local grade = criar_grade(tamanho_da_grade)

--------------------------------------------------------------------------------
-- Passo #5:  Executa o jogo:

while true do
  atualizar_grade(grade, jogador, inimigos)
  imprimir_grade(grade)

  local movimento = io.read()
  coroutine.resume(corrotina_do_jogador, movimento)
  coroutine.resume(corrotina_dos_inimigos)

  -- Verifica a condição de fim de jogo
  for _, inimigo in ipairs(inimigos) do
    if inimigo.x == jogador.x and inimigo.y == jogador.y then
      print("Fim de jogo! Os inimigos pegaram você!")
      os.exit()
    end
  end
end

--------------------------------------------------------------------------------
