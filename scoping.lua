-- scoping.lua

-- Declares a variable in the outermost scope:
local x = 10

-- Defines a block scope:
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

  print(x) --> 11 (inner x)
end

print(x) --> 10 (outer x)
