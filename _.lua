-- range.lua
-- Generates a sequence similar to python's range.

------------------------------------------------------------
-- Function definition:

local function rangeInputValidator(start, stop, step)
  -- Check if the inputs are numbers or nil:
  local checks = {
    stop ~= nil and type(start) == "number",
    stop == nil or type(stop) == "number",
    step == nil or type(step) == "number"
  }
  -- Create errorMsgs:
  local errorMsgs = {
    "Start value must be a number",
    "Stop value must be a number or nil",
    "Step value must be a number or nil"
  }
  
  -- Execute assertations:
  for n, check in ipairs(checks) do
    assert(check, errorMsgs[n])
  end
end

local function rangeInputHandler(start, stop, step)
  -- If only one argument is provided then:
  -- * it is considered as the 'stop' value
  -- * and 'start' is set to 1 by default.
  if not stop then stop, start = start, 1 end

  -- Get default value 'step':
  step = step or 1
  return start, stop, step
end

local function rangeNewIterator(start, stop, step)
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
  rangeInputValidator(start, stop, step)
  local _start, _stop, _step = rangeInputHandler(start, stop, step)
  return rangeNewIterator(_start, _stop, _step)
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
  range(3),         -- only one argument
  range(2, 5),      -- two arguments
  range(2, 6, 2),   -- all arguments
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

  -- Not number inputs
  -- print(execute(range("3"))) -- not number
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
