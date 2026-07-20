-- loaders.lua

----------------------------------------------------------------------
-- dofile:

-- Execute lua code from a external lua file:
-- file.lua = return "Hi Bob!"
local external_luafile = dofile("file.lua")
print(external_luafile) --> Hi Bob!


----------------------------------------------------------------------
-- loadfile:

-- Load string lua code from a external txt file.
-- file.txt = return "Hi Bob!"
local lua_chunk = loadfile("file.txt")
print(lua_chunk) --> function id

-- Execute Lua code stored in lua_chunk:
if lua_chunk then    -- need-check-nil
  print(lua_chunk()) --> Hi Bob!
end

----------------------------------------------------------------------
-- load:

-- Load lua code from a string code.
local chunk = "local name='Bob' print('Hello ' .. name)"
local compiledChunk = load(chunk)
print(compiledChunk) --> function id

-- Execute Lua code stored in compiledChunk:
if compiledChunk then -- need-check-nil
  compiledChunk()     --> Hello Bob
end

----------------------------------------------------------------------
