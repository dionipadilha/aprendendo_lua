-- range.lua

local function range(start, stop, step)
  if not stop then
    stop = start
    start = 1
  end
  step = step or 1
  local i = start - step
  return function()
    i = i + step
    return i <= stop and i or nil
  end
end

for value in range(3) do
  print(value) --> 1, 2, 3
end

for value in range(2, 5) do
  print(value) --> 2, 3, 4, 5
end

for value in range(2, 6, 2) do
  print(value) --> 2, 4, 6
end

local x = range(3)
for n in x do
  print(n) --> 1, 2, 3
end
