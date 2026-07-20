--------------------------------------------------------------------------------
-- test_suit.lua

local BasicUnitTest = require "basic_unit_test"
local busyWaitDelay = require "delay"

--------------------------------------------------------------------------------
-- processing simulation

local function doThis(n)
  busyWaitDelay(math.random(3)) -- processing
  return n + 1
end

local function doThat(w)
  busyWaitDelay(math.random(3)) -- processing
  return w .. "s"
end

--------------------------------------------------------------------------------
local TestSuite = {}

TestSuite.tests_doThis = BasicUnitTest:new {
  id = "Test #1 - doThis",
  test = doThis,
  cases = {
    { put = 1, expected = 2 },
    { put = 3, expected = 4 },
    { put = 5, expected = 6 }
  }
}

TestSuite.tests_doThat = BasicUnitTest:new {
  id = "Test #2 - doThat",
  test = doThat,
  cases = {
    { put = "bird", expected = "birds" },
    { put = "cat",  expected = "catsx" },
    { put = "dog",  expected = "dogs" }
  }
}

function TestSuite:run()
  self.tests_doThis:try()
  self.tests_doThat:try()
end

TestSuite:run()
--------------------------------------------------------------------------------
