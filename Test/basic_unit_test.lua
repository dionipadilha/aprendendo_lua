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
  exception = "[Exception] expected: %s, got: %s",
  finally = "[Done] exited in %f seconds"
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
    xpcall(
      assert,
      self.msgh,
      assertion,
      self.log.exception:format(expected, got)
    )
  end
  local stopwatchStop = os.clock()

  -- finally log the end of the tests:
  print(self.log.finally:format(stopwatchStop - stopwatchStart))
end

--[[----------------------------------------------------------------------------
-- exemple:

local myTests = BasicUnitTest:new {
  id = "Test #1 - Exemple",
  test = function(n) return n + 1 end,
  cases = {
    { put = 1, expected = 2 },
    { put = 3, expected = 4 },
    { put = 5, expected = 6 }
  }
}

myTests:try()
------------------------------------------------------------------------------]]

return BasicUnitTest
