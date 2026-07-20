-- coroutine_game.lua

--------------------------------------------------------------------------------
-- Step #1: Define the gameGrid and utilityFunctions:

local grid_size = 5

local function create_grid(size)
  local grid = {}
  for i = 1, size do
    grid[i] = {}
    for j = 1, size do
      grid[i][j] = '.'
    end
  end
  return grid
end

local function print_grid(grid)
  for i = 1, #grid do
    for j = 1, #grid[i] do
      io.write(grid[i][j] .. ' ')
    end
    print()
  end
end

local function clear_grid(grid)
  for i = 1, #grid do
    for j = 1, #grid[i] do
      grid[i][j] = '.'
    end
  end
end

--------------------------------------------------------------------------------
-- Step #2:  Define the player coroutines:

local player = { x = 1, y = 1 }

local function player_move(grid, player)
  while true do
    local move = coroutine.yield()
    if move == 'w' and player.x > 1 then
      player.x = player.x - 1
    elseif move == 's' and player.x < grid_size then
      player.x = player.x + 1
    elseif move == 'a' and player.y > 1 then
      player.y = player.y - 1
    elseif move == 'd' and player.y < grid_size then
      player.y = player.y + 1
    end
  end
end

--------------------------------------------------------------------------------
-- Step #3:  Define the enemies coroutines:

local enemies = {
  { x = 5, y = 5 },
  { x = 5, y = 1 }
}
local function enemy_move(grid, enemies, player)
  while true do
    for _, enemy in ipairs(enemies) do
      if enemy.x < player.x then
        enemy.x = enemy.x + 1
      elseif enemy.x > player.x then
        enemy.x = enemy.x - 1
      end
      if enemy.y < player.y then
        enemy.y = enemy.y + 1
      elseif enemy.y > player.y then
        enemy.y = enemy.y - 1
      end
    end
    coroutine.yield()
  end
end

--------------------------------------------------------------------------------
-- Step #4:  Initialize coroutines and mainGameLoop:

local player_coroutine = coroutine.create(player_move)
local enemy_coroutine = coroutine.create(enemy_move)

coroutine.resume(player_coroutine, create_grid(grid_size), player)
coroutine.resume(enemy_coroutine, create_grid(grid_size), enemies, player)

local function update_grid(grid, player, enemies)
  clear_grid(grid)
  grid[player.x][player.y] = 'P'
  for _, enemy in ipairs(enemies) do
    grid[enemy.x][enemy.y] = 'E'
  end
end

local grid = create_grid(grid_size)

--------------------------------------------------------------------------------
-- Step #5:  Run the game:

while true do
  update_grid(grid, player, enemies)
  print_grid(grid)

  local move = io.read()
  coroutine.resume(player_coroutine, move)
  coroutine.resume(enemy_coroutine)

  -- Check for game over condition
  for _, enemy in ipairs(enemies) do
    if enemy.x == player.x and enemy.y == player.y then
      print("Game Over! The enemies caught you!")
      os.exit()
    end
  end
end

--------------------------------------------------------------------------------
