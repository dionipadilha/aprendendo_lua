--------------------------------------------------------------------------------
-- basic_unit_test.lua

local BasicUnitTest = {
  id = "",
  test = function(case) return nil end,
  cases = {
    { put = nil, expected = nil },
  }
}

-- define constructor
function BasicUnitTest:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

-- define msgh used by xpcall:
function BasicUnitTest.msgh(exception)
  print(exception)
end

-- define logging:
BasicUnitTest.log = {
  run = "\n[Running] Unit Test: %s",
  fields = "[Fields] case, expected, got, assertion",
  test = "[-->] %s, %s, %s, %s",
  fail = "[Exception] expected: %s, got: %s",
  finally = "[Done] exited in %.3f seconds"
}

-- define test execution flow:
function BasicUnitTest:try()
  --
  -- log information about current setup:
  print(self.log.run:format(self.id))
  print(self.log.fields)

  -- test execution flow:
  local stopwatchStart = os.clock()
  for _, case in pairs(self.cases) do
    -- get test objects:
    local expected = case.expected
    local got = self.test(case.put)
    local assertion = (expected == got)
    print(self.log.test:format(case.put, expected, got, assertion))
    -- get possible exceptions:
    xpcall(assert, self.msgh, assertion, self.log.fail:format(expected, got))
  end
  local stopwatchStop = os.clock()

  -- finally log the end of the tests:
  print(self.log.finally:format(stopwatchStop - stopwatchStart))
end

-- return BasicUnitTest

--------------------------------------------------------------------------------
-- test_suit.lua
-- local BasicUnitTest = require "basic_unit_test"

local TestSuite = {}

TestSuite.tests_1 = BasicUnitTest:new {
  id = "tests #1",
  test = function(x) return x + 1 end,
  cases = {
    { put = 1, expected = 2 },
    { put = 3, expected = 4 },
    { put = 5, expected = 6 }
  }
}

TestSuite.tests_2 = BasicUnitTest:new {
  id = "tests #2",
  test = function(w) return w .. "s" end,
  cases = {
    { put = "bird", expected = "birds" },
    { put = "cat",  expected = "catsx" },
    { put = "dog",  expected = "dogs" }
  }
}

function TestSuite:run()
  self.tests_1:try()
  self.tests_2:try()
end

TestSuite:run()

--[[ show console log:

Running] Unit Test: tests #1
[Fields] case, expected, got, assertion
[-->] 1, 2, 2, true
[-->] 3, 4, 4, true
[-->] 5, 6, 6, true
[Done] exited in 0.000 seconds

[Running] Unit Test: tests #2
[Fields] case, expected, got, assertion
[-->] bird, birds, birds, true
[-->] cat, catsx, cats, false
[Exception] expected: catsx, got: cats
[-->] dog, dogs, dogs, true
[Done] exited in 0.000 seconds

]]
--------------------------------------------------------------------------------
