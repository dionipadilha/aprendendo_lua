-- select_where.lua

--------------------------------------------------------------------------------
-- Select elements from a list where a given criterion is true

local function selectWhere(list, criterion)
  -- Validate inputs:
  assert(
    type(list) == "table",
    "Expected a table as the first argument."
  )
  assert(
    type(criterion) == "function",
    "Expected a function as the second argument."
  )

  -- Select elements that match the criterion:
  local selectedList = {}
  for _, element in ipairs(list) do
    if criterion(element) then
      table.insert(selectedList, element)
    end
  end

  -- Return the selected list:
  return selectedList
end

--------------------------------------------------------------------------------
-- Usage example

-- List to be filtered:
local numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

-- Generic criteria functions:
local isEven = function(n) return n % 2 == 0 end
local isOdd = function(n) return n % 2 ~= 0 end

-- Select elements from the list based on criteria:
local evenNumbers = selectWhere(numbers, isEven)
local oddNumbers = selectWhere(numbers, isOdd)

-- Print the selected lists:
print("Even Numbers:", table.concat(evenNumbers, ", "))
print("Odd Numbers:", table.concat(oddNumbers, ", "))

--------------------------------------------------------------------------------
-- Unit tests

local function testSelectWhere()
  -- Test #1: Empty list
  assert(
    #selectWhere({}, isEven) == 0,
    "Test failed: Empty list"
  )

  -- Test #2: Numbers greater than 5
  local function isGreaterThanFive(n) return n > 5 end
  assert(
    #selectWhere(numbers, isGreaterThanFive) == 5,
    "Test failed: Numbers greater than 5"
  )

  -- Test #3: Negative numbers
  local negativeNumbers = { -1, -2, -3, -4, -5 }
  local evenNegativeNumbers = selectWhere(negativeNumbers, isEven)
  assert(
    #evenNegativeNumbers == 2,
    "Test failed: Even negative numbers #3.1"
  )
  assert(
    evenNegativeNumbers[1] == -2,
    "Test failed: Even negative numbers #3.2"
  )
  assert(
    evenNegativeNumbers[2] == -4,
    "Test failed: Even negative numbers #3.3"
  )

  -- Test #4: Different data types
  local mixedList   = { 1, "two", 3, "four" }
  local isNumber    = function(n) return type(n) == "number" end
  local numbersOnly = selectWhere(mixedList, isNumber)
  assert(
    #numbersOnly == 2 and numbersOnly[1] == 1 and numbersOnly[2] == 3,
    "Test failed: Mixed list numbers only"
  )

  -- All tests passed
  print("All tests passed.")
end

testSelectWhere()
--------------------------------------------------------------------------------
