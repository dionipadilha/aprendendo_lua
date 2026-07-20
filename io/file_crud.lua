-- file_crud.lua

local filename = "crud.txt"
local initial_content = "ana"
local updated_content = "bob"

-- creating and write content to a file:
do
  local file = assert(io.open(filename, "w"))
  file:write(initial_content)
  assert(file:close())
end

-- read content from a file
do
  local file = assert(io.open(filename, "r"))
  local content = file:read("*a")
  assert(content == initial_content)
  assert(file:close())
end

-- updating the content file:
do
  local file = assert(io.open(filename, "w+"))
  file:write(updated_content)
  assert(file:close())

  -- verifying the update
  file = assert(io.open(filename, "r"))
  local content = file:read("*a")
  assert(content == updated_content)
  assert(file:close())
end

-- deleting the file:
do
  os.remove(filename)

  -- verifying the deletion
  local file = io.open(filename)
  assert(file == nil)
end
