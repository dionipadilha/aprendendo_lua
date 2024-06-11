-- filter.lua

-- Function to check if a number is even
local function isEven(n)
  return n % 2 == 0
end

-- Function to check if a number is odd
local function isOdd(n)
  return n % 2 ~= 0
end

-- Function to filter a list based on a given criterion
local function filter(list, criterion)
  if type(list) ~= "table" then
    error("Expected a table as the first argument.", 2)
  end

  if type(criterion) ~= "function" then
    error("Expected a function as the second argument.", 2)
  end

  local filteredList = {}
  for _, element in ipairs(list) do
    if criterion(element) then
      table.insert(filteredList, element)
    end
  end
  return filteredList
end

-- List to be filtered
local numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

-- Filter the list
local evenNumbers = filter(numbers, isEven)
local oddNumbers = filter(numbers, isOdd)

-- Print the filtered list
print("Even Numbers:", table.concat(evenNumbers, ", "))
print("Odd Numbers:", table.concat(oddNumbers, ", "))
