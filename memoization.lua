-- memoization.lua
-- Caches results to avoid redundant calculations.

-- Initialize the memoization cache with the base case: 0! = 1
local cache = { [0] = 1 }

-- Factorial function with memoization
local function factorial(n)
  -- Handle negative inputs
  assert(n >= 0, "Factorial is not defined for negative numbers")

  -- Check for memoized results:
  if cache[n] then
    return cache[n], "retrieved from cache"
  end

  -- Memoize the recursively calculated factorial
  cache[n] = n * factorial(n - 1)
  return cache[n]
end

-- Example usage
print(factorial(5)) --> 120
print(factorial(6)) --> 720
print(factorial(7)) --> 5040
print(factorial(5)) --> 120	retrieved from cache
print(factorial(6)) --> 720	retrieved from cache
