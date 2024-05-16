--------------------------------------------------------------------------------
-- basic_unit_test.lua

local BasicUnitTest = {
  id = "",
  test = function(case) return nil end,
  cases = {},
  expecteds = {}
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
  run = "[Running] Unit Test: %s",
  fields = "[Fields] case, expected, got, assertion",
  test = "[-->] %s, %s, %s, %s",
  fail = "[Exception] expected: %s, got: %s",
  finally = "[Done] exited in %.3f seconds"
}

-- define test execution flow:
function BasicUnitTest:try()
  -- log information about current setup:
  print(self.log.run:format(self.id))
  print(self.log.fields)

  -- test execution flow:
  local stopwatchStart = os.clock()
  for n, case in pairs(self.cases) do
    -- get test objects:
    local got = self.test(case)
    local expected = self.expecteds[n]
    local assertion = (got == expected)
    print(self.log.test:format(case, expected, got, assertion))
    -- get possible exceptions:
    xpcall(assert, self.msgh, assertion, self.log.fail:format(expected, got))
  end
  local stopwatchStop = os.clock()

  -- finally log the end of the tests:
  local elapsedTime = stopwatchStop - stopwatchStart
  print(self.log.finally:format(elapsedTime))
end

-- return BasicUnitTest

--------------------------------------------------------------------------------
-- Usage:
--------------------------------------------------------------------------------
-- exemple.lua
-- local BasicUnitTest = require "basic_unit_test"

local tests = BasicUnitTest:new {
  id = "tests #1",
  test = function(x) return x + 1 end,
  cases = { 1, 3, 5 },
  expecteds = { 2, 4, 6 },
}
tests:try()

--[[
  [Running] Unit Test: tests #1
  [Fields] case, expected, got, assertion
  [-->] 1, 2, 2, true
  [-->] 3, 4, 4, true
  [-->] 5, 6, 6, true
  [Done] exited in 0.000 seconds
]]

local otherTests = BasicUnitTest:new {
  id = "tests #2",
  test = function(w) return w .. "s" end,
  cases = { "cat", "dog", "pig" },
  expecteds = { "cats", "dogsx", "pigs" },
}
otherTests:try()

--[[
  [Running] Unit Test: tests #2
  [Fields] case, expected, got, assertion
  [-->] cat, cats, cats, true
  [-->] dog, dogsx, dogs, false
  [Exception] expected: dogsx, got: dogs
  [-->] pig, pigs, pigs, true
  [Done] exited in 0.000 seconds
]]

--------------------------------------------------------------------------------
