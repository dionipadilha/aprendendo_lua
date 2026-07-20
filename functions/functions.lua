--------------------------------------------------------------------------------
-- Functions:
local function greet(name)
  print("Hello " .. name)
end
greet("Bob") --> Hello Bob

-- Multiple return values:
local function sumProduct(x, y)
  return x + y, x * y
end
local sum, product = sumProduct(2, 3)
print(sum, product) --> 5 6

-- Optional arguments:
local function greet(name, greeting)
  greeting = greeting or "Hello"
  print(greeting .. " " .. name)
end
greet("Bob") --> Hello Bob
greet("Bob", "Hi") --> Hi Bob

-- Named arguments:
local function greet(args)
  local name = args.name
  local greeting = args.greeting or "Hello"
  print(greeting .. " " .. name)
end
greet{name = "Bob"} --> Hello Bob
greet{name = "Bob", greeting = "Hi"} --> Hi Bob
greet{greeting = "Hi", name = "Bob"} --> Hi Bob

-- Variable number of arguments:
local function greet(...)
  local names = {...}
  for _, name in ipairs(names) do
    print("Hi " .. name)
  end
end
greet("Ana", "Bob", "Carlos") --> Hi Ana, Hi Bob, Hi Carlos

--------------------------------------------------------------------------------
-- Anonymous function:
print((function(x) return 2*x end)(3)) --> 6
print((function(x) return 2*x end)(5)) --> 10

-- Variable with anonymous functions:
local greet = function(name)
  print("Hi " .. name)
end
greet("Bob") --> Hi Bob

-- Anonymous function with arguments:
local greet = function(name, greeting)
  print(greeting .. " " .. name)
end
greet("Bob", "Hey") --> Hey Bob

--------------------------------------------------------------------------------
-- First-class functions:
local function greet(name)
  return function()
    print("Hi " .. name)
  end
end
local greetAna = greet("Ana")
local greetBob = greet("Bob")
greetAna() --> Hi Ana
greetBob() --> Hi Bob


-- Higher-order function:
local function greet(name, callback)
  callback(name)
end
greet("Bob", print) --> Bob
greet("Bob", function(name) print("Hi " .. name) end) --> Hi Bob

-- Closures:
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
print(count()) --> 3

-- Recursion:
local function factorial(n)
  if n == 0 then return 1
  else return n * factorial(n - 1)
  end
end
print(factorial(5)) --> 120

--------------------------------------------------------------------------------
-- Error handling:
local status, result = pcall(function() error("Some error") end)
print(status) --> false
print(result) --> Some error

local status, result = pcall(function() return "Some result" end)
print(status) --> true
print(result) --> Some result

--------------------------------------------------------------------------------
-- Tail recursion:
local function factorial(n, acc)
  if n == 0 then return acc
  else return factorial(n - 1, n * acc)
  end
end
print(factorial(5, 1)) --> 120

-- Anonymous recursion:
local factorial
factorial = function(n)
  if n == 0 then return 1
  else return n * factorial(n - 1)
  end
end
print(factorial(5)) --> 120

-- Memoization:
local memo = {}
local function factorial(n)
  if n == 0 then return 1
  else
    if not memo[n] then
      memo[n] = n * factorial(n - 1)
    end
    return memo[n]
  end
end
print(factorial(5)) --> 120
print(factorial(5)) --> 120
print(factorial(6)) --> 720
print(factorial(6)) --> 720

-- Currying:
local function add(x)
  return function(y)
    return x + y
  end
end
local add2 = add(2)
print(add2(3)) --> 5
print(add2(5)) --> 7

-- Partial application:
local function add(x, y)
  return x + y
end
local add2 = function(y) return add(2, y) end
print(add2(3)) --> 5
print(add2(5)) --> 7

-- Composition:
local function add2(x)
  return x + 2
end
local function mul3(x)
  return x * 3
end
local function compose(f, g)
  return function(x)
    return f(g(x))
  end
end
local add2ThenMul3 = compose(mul3, add2)
print(add2ThenMul3(5)) --> 21

-- Pipe:
local function add2(x)
  return x + 2
end
local function mul3(x)
  return x * 3
end
local function pipe(f, g)
  return function(x)
    return g(f(x))
  end
end
local add2ThenMul3 = pipe(add2, mul3)
print(add2ThenMul3(5)) --> 21
