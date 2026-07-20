-- carregadores.lua

-- (execute a partir deste diretório: dofile e loadfile procuram os
-- arquivos no diretório corrente, não relativo a este script)

----------------------------------------------------------------------
-- dofile:

-- Executa código Lua de um arquivo Lua externo:
-- arquivo.lua = return "Oi Bob!"
local arquivoLuaExterno = dofile("arquivo.lua")
print(arquivoLuaExterno) --> Oi Bob!
assert(arquivoLuaExterno == "Oi Bob!")

----------------------------------------------------------------------
-- loadfile:

-- Carrega código Lua em string de um arquivo txt externo.
-- arquivo.txt = return "Oi Bob!"
local trechoLua = loadfile("arquivo.txt")
print(trechoLua) --> function: 0x... (o endereço varia)
assert(type(trechoLua) == "function")

-- Executa o código Lua armazenado em trechoLua:
if trechoLua then     -- need-check-nil
  local retorno = trechoLua()
  print(retorno) --> Oi Bob!
  assert(retorno == "Oi Bob!")
end

----------------------------------------------------------------------
-- load:

-- Carrega código Lua a partir de uma string de código.
local trecho = "local nome='Bob' print('Olá ' .. nome)"
local trechoCompilado = load(trecho)
print(trechoCompilado) --> function: 0x... (o endereço varia)
assert(type(trechoCompilado) == "function")

-- Executa o código Lua armazenado em trechoCompilado:
if trechoCompilado then -- need-check-nil
  trechoCompilado()     --> Olá Bob
end

----------------------------------------------------------------------
