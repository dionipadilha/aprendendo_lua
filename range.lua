-- range.lua

------------------------------------------------------------
-- Generates a sequence similar to python's range:

local function range(start, stop, step)
  if not stop then stop, start = start, 1 end
  step = step or 1
  local i = start - step
  return function()
    i = i + step
    if step < 0 then return i >= stop and i or nil end
    return i <= stop and i or nil
  end
end

------------------------------------------------------------
-- Test cases:

local function printCase(rangeGen)
  local t = {}
  for n in rangeGen do table.insert(t, n) end
  return table.concat(t, ", ")
end

local oddNumbers = range(1, 10, 2)

local cases = {
  printCase(range(3)) == "1, 2, 3",
  printCase(range(2, 5)) == "2, 3, 4, 5",
  printCase(range(2, 6, 2)) == "2, 4, 6",
  printCase(range(-5, -1, 2)) == "-5, -3, -1",
  printCase(range(5, 1, -2)) == "5, 3, 1",
  printCase(oddNumbers) == "1, 3, 5, 7, 9"
}

for n, case in ipairs(cases) do
  assert(case, "Error case: " .. n)
end

------------------------------------------------------------
return range
