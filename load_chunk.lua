-- load_chunk.lua

-- Dynamically execute Lua code stored as a string.

-- Define some Lua code as a string:
local chunk = "local name='Bob' print('Hello ' .. name)"

-- Execute the loaded chunk as a function
local compiledChunk = load(chunk)

print(compiledChunk) --> function id
if compiledChunk then
  compiledChunk()    --> Hello Bob
end
