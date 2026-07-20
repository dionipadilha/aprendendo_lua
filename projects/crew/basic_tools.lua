-- basic_tools.lua

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

local subtractor = Tool:new {
  name = "subtractor",
  description = "Subtract second number from the first number",
  run = function(self, first_number, second_number)
    assert(type(first_number) == "number", "Inputs must be numbers.")
    assert(type(second_number) == "number", "Inputs must be numbers.")
    return first_number - second_number
  end
}

local multiplicator = Tool:new {
  name = "multiplicator",
  description = "multiply two numbers together",
  run = function(self, first_number, second_number)
    assert(type(first_number) == "number", "Inputs must be numbers.")
    assert(type(second_number) == "number", "Inputs must be numbers.")
    return first_number * second_number
  end
}

local divider = Tool:new {
  name = "divider",
  description = "Divide the first number by the second number",
  run = function(self, first_number, second_number)
    assert(type(first_number) == "number", "Inputs must be numbers.")
    assert(type(second_number) == "number", "Inputs must be numbers.")
    assert(type(second_number) ~= 0, "Division by zero is not allowed.")
    return first_number / second_number
  end
}

-- basic assertions:
assert(multiplicator:run(2, 3) == 6)
assert(adder:run(2, 3) == 5)
assert(subtractor:run(5, 3) == 2)
assert(divider:run(6, 3) == 2)

return {
  adder = adder,
  subtractor = subtractor,
  multiplicator = multiplicator,
  divider = divider
}

--------------------------------------------------------------------------------
