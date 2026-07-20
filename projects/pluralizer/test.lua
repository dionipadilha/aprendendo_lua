-- test.lua

--------------------------------------------------------------------------------
-- Define the function you want to test:
local myFunction = require "main"

--------------------------------------------------------------------------------
-- Define your test cases as a table of input-output pairs:
local myTestCases = require "validation"

--------------------------------------------------------------------------------
-- Run tests:

-- Test execution function:
local function execute(testFunction, case, expected)
  print(case .. " --> " .. expected)
  local log = "\nFail: expected '%s', got '%s'"
  local got = testFunction(case)
  return assert(expected == got, log:format(expected, got))
end

-- Test runner function:
local function run(testFunction, testCases)
  --
  assert(testFunction, "Test function must be provided")
  assert(testCases, "Test cases must be provided")
  --
  for case, expected in pairs(testCases) do
    local ok, exception = pcall(execute, testFunction, case, expected)
    if not ok then
      print(exception)
      return
    end
  end
  print("All tests passed!")
end

--------------------------------------------------------------------------------
-- Run the tests
run(myFunction, myTestCases) --> All tests passed!
--------------------------------------------------------------------------------
