-- Return values

-- Return value:
local function add(x, y)
  return x + y
end
local sum = add(2, 3)
print(sum) --> 5

-- Multiple return values:
local function sumProduct(x, y)
  return x + y, x * y
end
local sum, product = sumProduct(2, 3)
print(sum, product) --> 5 6

-- Returning based on condition:
local function max(x, y)
  return x > y and x or y
end
print(max(2, 3)) --> 3

-- Returning a table:
local function getBasicOperations(x, y)
  return {
    sum = x + y,
    difference = x - y,
    product = x * y,
    quotient = x / y
  }
end
local result = getBasicOperations(2, 3)
print(result.sum, result.product) --> 5 6

-- Returning a function:
local function multiplier(factor)
  return function(x)
    return x * factor
  end
end
local double = multiplier(2)
local triple = multiplier(3)
print(double(5))  --> 10
print(triple(5))  --> 15

-- Returning a closure:
local function counter()
  local count = 0
  return function()
    count = count + 1
    return count
  end
end
local count = counter()
print(count()) --> 1
print(count()) --> 2
print(count()) --> ...

-- Returning a recursive function:
local function factorial(n)
  if n == 0 then return 1
  else return n * factorial(n - 1)
  end
end
print(factorial(5)) --> 120

-- Returning a variable number of values:
local function pack(...)
  return {...}
end
local values = pack(1, 2, 3, "hello")
for _, v in ipairs(values) do
  print(v) --> 1, 2, 3, hello
end
