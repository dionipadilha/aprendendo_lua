local function switch(case)
  -- Define a table to hold all possible cases
  local cases = {
    x = function() print("This is case 1") end,
    y = function() print("This is case 2") end,
    z = function() print("This is case 3") end,
    -- Add more cases as needed
    default = function() print("This is the default case") end
  }
  return (cases[case] or cases["default"])()
end

local userInputs = { "x", "z", 0, "" }

for _, value in ipairs(userInputs) do
  switch(value)
end
