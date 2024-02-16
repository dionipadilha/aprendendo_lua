# Getting Started with Lua

Lua is a versatile and efficient scripting language.

Tips for learning Lua:

- The best way to learn Lua is by writing Lua code.
- Experiment by modifying examples and practicing.

## Essential Lua Programming

The following snippets cover essential aspects of Lua programming:

- Basic Syntax:

```lua
-- single line comment
print("Hello, World!") --> side comment

--[[
  This is a
    multi-line
      comment.
--]]
```

- Data Types:

```lua
local number = 10
local string = "Lua"
local boolean = true
local table = {item1, item2, item3} -- list, array
local table = {key_1 = "str", key_2 = 30} -- dictionary, map
local x = nil -- represents absence of value
```

- Conditional:

```lua
if number > 5 then print("Number is greater than 5")
elseif number < 5 then print("Number is less than 5")
else print("Number is 5")
end
```

- Looping constructs

```lua
-- For loop:
for i = 1, 5 do print(i) end

-- While loop:
local i = 1
while i <= 5 do
  print(i)
  i = i + 1
end
```

- Functions

```lua
-- Lua supports first-class functions and closures.

-- Functions definition
function greet(name)
  print("Hello, " .. name)
end

-- Functions invocation
greet("Alice")
```

- Tables

```lua
-- Tables in Lua are the only data structuring mechanism.

-- list, arrays
local list = {item1, item2, item3}
print(list[1]) --> item1

-- map, dictionaries
local table = {key1 = "value1", key2 = "value2"}
print(table["key1"]) --> value1

-- objects
local person = {name = "bob", age = 30}
print(person.name)  --> bob
print(person.age)  --> 30
```

- Error handling

```lua
-- Error handling with pcall function
if pcall(function_that_might_fail) then print("Success")
else print("Failure")
end
```

- File operations

```lua
-- Writing to a file
local file = io.open("test.txt", "w")
file:write("Hello, Lua!")
file:close()

-- Reading from a file
local file = io.open("test.txt", "r")
local content = file:read("*a")
print(content)
file:close()
```

## Explore more advanced features

Advanced Lua features:

- metatables
- coroutines
- modules
- Lua's C API
- debugging tools
- garbage collector

For detailed documentation see:

- [official Lua website](http://www.lua.org/manual/).
- Lua repositories and libraries.

## Lua Code Exemples

Exemple #1:

```lua
--[[------------------------------------------------------------
  Create a program that prints the numbers 1 to 10, but:
    - for multiples of 3, it prints "Fizz",
    - for multiples of 5, it prints "Buzz",
    - For numbers which are multiples of both 3 and 5, it prints "FizzBuzz".
]]

----------------------------------------------------------------
for i = 1, 10 do
    if i % 3 == 0 and i % 5 == 0 then
        print("FizzBuzz")
    elseif i % 3 == 0 then
        print("Fizz")
    elseif i % 5 == 0 then
        print("Buzz")
    else
        print(i)
    end
end
```

Exemple #2:

```lua
--[[------------------------------------------------------------
  Create a Lua function that performs basic arithmetic operations.
    - addition, subtraction, multiplication, and division.
    - function arguments: two numbers and an operation.
]]

----------------------------------------------------------------
function evaluate(head, a, b)
  local operations = {
    plus = function(a, b) return a + b end,
    subtract = function(a, b) return a - b end,
    multiply = function(a, b) return a * b end,
    divide = function(a, b)
      if b ~= 0 then return a / b
        else return nil, "Error: Division by zero"
      end
    end
  }

  if operations[head] then return operations[head](a, b)
    else return nil, "Invalid operation"
  end
end

-- Example usage
local result, error = evaluate("plus", 2, 3)
if error then print(error) else print(result) end  -- 5

result, error = evaluate("divide", 2, 0)
if error then print(error) else print(result) end  -- Error: Division by zero

```
