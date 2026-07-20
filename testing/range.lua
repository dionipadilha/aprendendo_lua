-- range.lua

-- Generates a sequence of numbers.

local function inputHandler(start, stop, step)
  -- If only one arg is provided, it sets the stop:
  if not stop then
    stop, start = start, 1
  end
  -- Default step is 1 if not provided:
  step = step or 1
  return start, stop, step
end

local function getIterator(start, stop, step)
  local i = start - step
  return function()
    i = i + step
    -- Increments or decrements i based on the step value:
    if step < 0 then
      -- generates a decreasing sequence:
      return i >= stop and i or nil
    else
      -- generates a increasing sequence:
      return i <= stop and i or nil
    end
  end
end

local function range(start, stop, step)
  start, stop, step = inputHandler(start, stop, step)
  return getIterator(start, stop, step)
end

return range
