-- range_reverse.lua

local function onlyStopHandler(start, stop, step)
  if start > stop then
    if not stop then
      stop = start
      start = 1
      step = 1
    elseif not step then
      start = start
      stop = stop
      step = 1
    else
    end
  else
  end
  return start, stop, step
end


local function reverseHandler(start, stop, step)
  -- try it
  return start, stop, step
end

local function range(start, stop, step)
  start, stop, step = onlyStopHandler(start, stop, step)
  start, stop, step = reverseHandler(start, stop, step)

  local i = start - step

  return function()
    i = i + step
    return i <= stop and i or nil
  end
end


-- Starting from 1 up to the n:
for value in range(3) do
  print(value) --> 1, 2, 3
end

-- Increment between values:
for value in range(2, 5) do
  print(value) --> 2, 3, 4, 5
end

-- Specifying the incrementation:
for value in range(2, 6, 2) do
  print(value) --> 2, 4, 6
end


local sequence = range(1, 10, 2)
for number in sequence do
  print(number) --> 1, 3, 5, 7, 9
end

-- Reverse range from 5 to 1
for value in range(5, 1, -1) do
  print(value) --> 5, 4, 3, 2, 1
end
