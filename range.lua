-- range.lua

---------------------------------------------------------------
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
---------------------------------------------------------------
local t = {}
table.print = function(self) print(table.concat(self, ", ")) end

-- Starting from 1 up to the n:
t = {}
for n in range(3) do
  table.insert(t, n)
end
table.print(t) --> 1, 2, 3

-- Increment between values:
t = {}
for n in range(2, 5) do
  table.insert(t, n)
end
table.print(t) --> 2, 3, 4, 5

-- Specifying the incrementation:
t = {}
for n in range(2, 6, 2) do
  table.insert(t, n)
end
table.print(t) --> 2, 4, 6

--
t = {}
local sequence = range(1, 10, 2)
for n in sequence do
  table.insert(t, n)
end
table.print(t) --> 1, 3, 5, 7, 9

-- Reverse range from 5 to 1
t = {}
for n in range(5, 1, -1) do
  table.insert(t, n)
end
table.print(t) --> 5, 4, 3, 2, 1
