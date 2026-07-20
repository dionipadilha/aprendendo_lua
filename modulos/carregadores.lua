-- carregadores.lua

----------------------------------------------------------------------
-- dofile:

-- Executa código Lua de um arquivo Lua externo:
-- arquivo.lua = return "Oi Bob!"
local arquivo_lua_externo = dofile("arquivo.lua")
print(arquivo_lua_externo) --> Oi Bob!


----------------------------------------------------------------------
-- loadfile:

-- Carrega código Lua em string de um arquivo txt externo.
-- arquivo.txt = return "Oi Bob!"
local trecho_lua = loadfile("arquivo.txt")
print(trecho_lua) --> id da função

-- Executa o código Lua armazenado em trecho_lua:
if trecho_lua then    -- need-check-nil
  print(trecho_lua()) --> Oi Bob!
end

----------------------------------------------------------------------
-- load:

-- Carrega código Lua a partir de uma string de código.
local trecho = "local nome='Bob' print('Olá ' .. nome)"
local trechoCompilado = load(trecho)
print(trechoCompilado) --> id da função

-- Executa o código Lua armazenado em trechoCompilado:
if trechoCompilado then -- need-check-nil
  trechoCompilado()     --> Olá Bob
end

----------------------------------------------------------------------
