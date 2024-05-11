-- range.lua
-- Generates a sequence similar to python's range.

------------------------------------------------------------
-- Function definition:

local function inputValidation(start, stop, step)

  -- If only one argument is provided then:
  -- * it is considered as the 'stop' value;
  local isOnlyOneArg = not stop and not step
  if isOnlyOneArg then
    local check = type(start) == "number" and start > 0
    assert(check,"Stop value must be a positive number." )
  return true
end

local function InputHandling(start, stop, step)
  -- If only one argument is provided then:
  -- * it is considered as the 'stop' value
  -- * and 'start' is set to 1 by default.
  if not stop then
    assert(
      type(start) == "number" and start > 0,
      "Stop value must be a positive number."
    )
    stop, start = start, 1
    step = 1
  end

  -- If two arguments are provided then:
  if not step then
    assert(type(step) == "number" and stop > 0,)
  end

  return start, stop, step
end

local function getIterator(start, stop, step)
  local i = start - step
  return function()
    i = i + step
    -- Increments or decrements i based on the step value:
    if step < 0 then -- generates a decreasing sequence:
      return i >= stop and i or nil
    else             -- generates a increasing sequence:
      return i <= stop and i or nil
    end
  end
end

local function range(start, stop, step)
  inputValidation(start, stop, step)
  local _start, _stop, _step = InputHandling(start, stop, step)
  return getIterator(_start, _stop, _step)
end

------------------------------------------------------------
-- Function Validation:

-- Expected Usage:
local function execute(rangeIterator)
  -- collect all values into a table:
  local elements = {}
  for n in rangeIterator do table.insert(elements, n) end

  -- formats the table elements into a string:
  local formatedResult = table.concat(elements, ", ")
  return formatedResult
end

local testes = {
  -- only one argument:
  range(3),
  --range("3"),
  --range(-3),
  -- two arguments
  range(2, 5),
  -- all arguments
  range(2, 6, 2),   
  range(-5, -1, 2), -- negative start/stop
  range(5, 1, -2),  -- negative step
}

local expected = {
  "1, 2, 3",
  "2, 3, 4, 5",
  "2, 4, 6",
  "-5, -3, -1",
  "5, 3, 1",
  "1, 3, 5, 7, 9"
}

local function runUnitTests()
  -- Expected Usage:
  local failMsg = "Fail testing #%d: %s, got %s."
  for n, test in ipairs(testes) do
    local obtained = execute(test)
    local errorMsg = string.format(failMsg, n, expected[n], obtained)
    assert(expected[n] == obtained, errorMsg)
  end

  -- Edge Cases
  --print(execute(range("3"))) -- not number
  --print(execute(range(-3))) -- Negative stop
end

runUnitTests()
------------------------------------------------------------
-- Function Usage:

-- Use range as a sequence:
local oddNumbers = range(1, 5, 2)
for n in oddNumbers do print(n, n ^ 2) end
--> 1 1.0
--> 3 9.0
--> 5 25.0

------------------------------------------------------------
return range
