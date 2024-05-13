local range = require "range"

local function seq(rangeIterator)
  local t = {}
  for n in rangeIterator do table.insert(t, n) end
  return table.concat(t, ", ")
end

local function normalCases()
  assert(seq(range(3)) == "1, 2, 3", "test #1")
  assert(seq(range(3, 6)) == "3, 4, 5, 6", "test #2")
  assert(seq(range(3, 9, 2)) == "3, 5, 7, 9", "test #3")
  assert(seq(range(-6, -3, 1)) == "-6, -5, -4, -3", "test #4")
  assert(seq(range(6, 3, -1)) == "6, 5, 4, 3", "test #5")
end

local function edgeCases()
  assert(seq(range(0)) == "", "test #6")
  assert(seq(range(-3)) == "", "test #7")
  assert(seq(range(9, 6)) == "", "test #8")
  assert(seq(range(9, 6, 2)) == "", "test #9")
  assert(seq(range(6, 9, -2)) == "", "test #10")
end

local function unitTest()
  normalCases()
  edgeCases()
  print("UnitTest handles different scenarios correctly!")
  return true
end

local function errorHandler(errorMsg)
  print("Fail: ", errorMsg)
end

xpcall(unitTest, errorHandler)
