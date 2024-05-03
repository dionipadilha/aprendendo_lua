-- arguments.lua

-- No arguments:
local function greet()
  print("Hello")
end
greet() --> Hello

-- Single argument:
local function greet(name)
  print("Hi " .. name)
end
greet("Ana") --> Hi Ana
greet("Bob") --> Hi Bob

-- Multiples arguments:
local function greet(name, greeting)
  print(greeting .. " " .. name)
end
greet("Ana", "Hi")  --> Hi Ana
greet("Bob", "Hey") --> Hey Bob

-- Required arguments:
local function greet(name, greeting)
  assert(name, "name is required")
  assert(greeting, "greeting is required")
  print(greeting .. " " .. name)
end
greet("Ana", "Hi") --> Hi Ana
-- greet("Bob") --> error: name and greeting are required

-- Default arguments:
local function greet(name, greeting)
  local _name = name or "Ana"
  local _greeting = greeting or "Hi"
  print(_greeting .. " " .. _name)
end
greet()             --> Hi Ana
greet("Bob")        --> Hi Bob
greet("Bob", "Hey") --> Hey Bob

-- Variable number of arguments:
local function greet(...)
  local names = { ... }
  for _, name in ipairs(names) do
    print("Hi " .. name)
  end
end
greet("Ana")        --> Hi Ana
greet("Ana", "Bob") --> Hi Ana, Hi Bob

-- Mixing regular and variable number of arguments:
local function greet(greeting, ...)
  local names = { ... }
  for _, name in ipairs(names) do
    print(greeting .. " " .. name)
  end
end
greet("Hi", "Ana")         --> Hi Ana
greet("Hey", "Ana", "Bob") --> Hey Ana, Hey Bob

-- Named arguments:
local function greet(args)
  local name = args.name
  local greeting = args.greeting
  print(greeting .. " " .. name)
end
greet { name = "Ana", greeting = "Hi", } --> Hi Ana
greet { name = "Bob", greeting = "Hey", } --> Hey Bob
greet { greeting = "Bye", name = "Jhon" } --> Bye Jhon

-- Functions as arguments (Higher-Order Functions):
local function greet(name, callback)
  callback(name)
end
greet("Bob", print)                                   --> Bob
greet("Bob", function(name) print("Hi " .. name) end) --> Hi Bob
