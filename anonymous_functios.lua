-- Anonymous Functions

-- Anonymous function execution:
local y = (function(x) return 2 * x end)(3)
print(y) --> 6

-- Variable with anonymous functions:
local doubler = function(x) return 2 * x end
print(doubler(3)) --> 6
print(doubler(5)) --> 10

-- Anonymous function with multiple arguments:
local plus = function(a, b) return a + b end
print(plus(2, 3)) --> 5
print(plus(5, 7)) --> 12

-- Anonymous function and First-class functions:
local function multiplyBy(x)
  return function(y)
    return x * y
  end
end
local timesTwo = multiplyBy(2)
local timesFive = multiplyBy(5)
print(timesTwo(3))  --> 6
print(timesFive(3)) --> 15

-- Anonymous function and  Higher-order function:
local function evaluate(f, x)
  return print(f(x))
end
evaluate(function(x) return x ^ (1 / 2) end, 9) --> 3.0
evaluate(function(x) return x ^ 2 end, 3)       --> 9.0

-- Anonymous function and Closures:
local function newCounter()
  local i = 0
  return function()
    i = i + 1
    return i
  end
end
local count = newCounter()
print(count()) --> 1
print(count()) --> 2
print(count()) --> 3
