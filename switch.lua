--------------------------------------------------------------------------------
-- switch Function

local function switch(cases, value)
  assert(type(cases) == "table", "Invalid table cases")
  assert(cases["default"], "Provide the default case")
  assert(
    type(value) == "string" or type(value) == "number",
    "value must be a string or number"
  )
  local action = cases[value] or cases["default"]
  assert(type(action) == "function", "action must be a function")
  return action()
end

--------------------------------------------------------------------------------
-- Example Usage #1

local students = {
  ana = function() print("This is case 1") end,
  bob = function() print("This is case 2") end,
  charlie = function() print("This is case 3") end,
  -- Add more cases as needed
  default = function() print("This is the default case") end
}

switch(students, "ana")  --> This is case 1
switch(students, "bob")  --> This is case 2
switch(students, "duda") --> This is the default case

--------------------------------------------------------------------------------
-- Example Usage #2

local friends = {
  jhon = function() print("This is case 1") end,
  jane = function() print("This is case 2") end,
  jack = function() print("This is case 3") end,
  -- Add more cases as needed
  default = function() print("This is the default case") end
}

switch(friends, "jack") --> This is case 3
switch(friends, "bob")  --> This is the default case
--------------------------------------------------------------------------------
