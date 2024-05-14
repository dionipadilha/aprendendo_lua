-- main.lua

--------------------------------------------------------------------------------
-- #1: Create tools

local Tool = require "tool"

local adder = Tool:new {
  name = "adder",
  description = "add two numbers together",
  run = function(self, first_number, second_number)
    assert(type(first_number) == "number", "Inputs must be numbers.")
    assert(type(second_number) == "number", "Inputs must be numbers.")
    return first_number + second_number
  end
}
assert(adder:run(2, 3) == 5)

local subtractor = Tool:new {
  name = "subtractor",
  description = "Subtract second number from the first number",
  run = function(self, first_number, second_number)
    assert(type(first_number) == "number", "Inputs must be numbers.")
    assert(type(second_number) == "number", "Inputs must be numbers.")
    return first_number - second_number
  end
}
assert(subtractor:run(2, 3) == -1)

local multiplicator = Tool:new {
  name = "multiplicator",
  description = "multiply two numbers together",
  run = function(self, first_number, second_number)
    assert(type(first_number) == "number", "Inputs must be numbers.")
    assert(type(second_number) == "number", "Inputs must be numbers.")
    return first_number * second_number
  end
}
assert(multiplicator:run(2, 3) == 6)

--------------------------------------------------------------------------------
-- #2: Create Agents

local Agent = require "agent"

local Ana = Agent:new {
  role = "Generalist Explorer",
  goal = "Discover new mathematical formulas",
  backstory = [[Once a mathematician in a renowned university,
  Ana now explores uncharted territories of numbers and equations.]],
  tools = { adder, multiplicator }
}
assert(Ana.role == "Generalist Explorer")

local Bob = Agent:new {
  role = "Specialist Subtraction Explorer",
  goal = "Manipulate negative numbers",
  backstory = [[Once a mathematician in a renowned university,
  Bob now explores uncharted territories of negative numbers.]],
  tools = { subtractor }
}
assert(Bob.role == "Specialist Subtraction Explorer")

--------------------------------------------------------------------------------
-- #3: Agents using Tools

local App = {
  try = function()
    assert(Ana:use(adder, 2, 3) == 5)
    assert(Ana:use(multiplicator, 2, 3) == 6)
    assert(Bob:use(subtractor, 2, 3) == -1)
  end,

  except = function(exception)
    print("Error: " .. exception)
  end
}

local finally = xpcall(App.try, App.except)
print(finally and "All actions executed successfully!")

--------------------------------------------------------------------------------
-- #4 any suggestion?
