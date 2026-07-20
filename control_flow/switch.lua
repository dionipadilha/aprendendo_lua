-- switch.lua
-- executes a case based on the provided value

--------------------------------------------------------------------------------
-- Defines switch function


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
-- Test basic case selection

local students = {
  default = function() print("This is the default case") end,
  -- Add cases
  ana = function() print("This is Ana's case") end,
  bob = function() print("This is Bob's case") end,
  charlie = function() print("This is Charlie's case") end,
}

switch(students, "ana")  --> This is Ana's case
switch(students, "bob")  --> This is Bob's case
switch(students, "duda") --> This is the default case

--------------------------------------------------------------------------------
-- Test method style

local friends = {
  switch = switch,
  default = function() print("This is the default case") end,
  -- Add cases
  john = function() print("This is John's case") end,
  jane = function() print("This is Jane's case") end,
  jack = function() print("This is Jack's case") end,
}

friends:switch("jack") --> This is Jack's case
friends:switch("bob")  --> This is the default case
--------------------------------------------------------------------------------
