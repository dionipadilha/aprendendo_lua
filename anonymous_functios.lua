-- Anonymous Functions

-- Anonymous function execution:
local y = (function(x) return 2 * x end)(3)
assert(y == 6)

-- Variable with anonymous functions:
local doubler = function(x) return 2 * x end
assert(doubler(3) == 6)
assert(doubler(5) == 10)

-- Anonymous function with multiple arguments:
local add = function(a, b) return a + b end
assert(add(2, 3) == 5)
assert(add(5, 7) == 12)

-- Anonymous function and First-class functions:
local function multiplyBy(x)
  return function(y)
    return x * y
  end
end
local timesTwo = multiplyBy(2)
local timesFive = multiplyBy(5)
assert(timesTwo(3) == 6)
assert(timesFive(3) == 15)

-- Anonymous function and  Higher-order function:
local function evaluate(f, x)
  return f(x)
end
assert(evaluate(function(x) return x ^ (1 / 2) end, 9) == 3.0)
assert(evaluate(function(x) return x ^ 2 end, 3) == 9.0)

-- Anonymous function and Closures:
local function newCounter()
  local i = 0
  return function()
    i = i + 1
    return i
  end
end
local count = newCounter()
assert(count() == 1)
assert(count() == 2)
assert(count() == 3)
