-- error.lua

--------------------------------------------
-- Details:

-- Stops the execution and raising an error.

-- syntax: error(message, level?)
-- Returns:

--------------------------------------------
-- Basic examples:
local age = 1
if age < 0 then error("log #1: Age cannot be negative.") end
if age == 0 then error("log #2: Age cannot be zero.", 2) end
print("log #3: after error.")

--------------------------------------------
-- See Also: assert, pcall, xpcall
