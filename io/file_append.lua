-- file_append.lua

-- appending a random content:
do
  local randomTxt = "Now the file has more content: %f\n"
  for i = 1, 3 do
    local file = assert(io.open("demofile.txt", "a"))
    file:write(randomTxt:format(math.random()))
    assert(file:close())
  end
end

-- reading the file lines:
do
  local file = assert(io.open("demofile.txt"))
  local lines = {}
  for line in file:lines() do table.insert(lines, line) end
  assert(file:close())

  -- do something process:
  table.sort(lines)

  -- print the processed lines:
  for _, line in ipairs(lines) do print(line) end
end
