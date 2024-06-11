-- filter.lua

-- Function to filter a list based on a given criterion:
local function filter(list, crit)
  --
  local expected = {
    type(list) == "table",
    type(crit) == "function",
  }
  assert(expected[1], "Expected a table as the first argument.")
  assert(expected[2], "Expected a function as the second argument.")

  --
  local filteredList = {}
  for _, element in ipairs(list) do
    if crit(element) then
      table.insert(filteredList, element)
    end
  end

  --
  return filteredList
end

-- Generic filters:
local function isEven(n)
  return n % 2 == 0
end

local function isOdd(n)
  return n % 2 ~= 0
end

-- List to be filtered
local numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

-- Filter the list
local evenNumbers = filter(numbers, isEven)
local oddNumbers = filter(numbers, isOdd)

-- Print the filtered list
print("Even Numbers:", table.concat(evenNumbers, ", "))
print("Odd Numbers:", table.concat(oddNumbers, ", "))
