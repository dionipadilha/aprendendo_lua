-- scoping.lua

-- local variables declared within blocks create their own scopes.

-- Declares a variable in the outermost scope:
local x = 10

-- Defines the first block scope scope:
do
  local x = x -- inner x <-- outer x
  print(x)    --> 10
  x = x + 1   -- inner x --> 11

  -- Defines a nested block scope:
  do
    local x = x -- nested x <-- inner x
    print(x)    --> 11
    x = x + 1   -- nested x --> 12
    print(x)    --> 12
  end

  -- Exits the nested block scope:
  print(x) --> 11 (inner x)
end

-- Exits the outer block scope:
print(x) --> 10 (outer x)
