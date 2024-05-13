-- assert.lua

--------------------------------------------
-- Details:

-- Raising an error based on a condition.

-- syntax: assert(condition, [errorMsg])
-- Returns:

--------------------------------------------
-- Basic examples:
local age = 1
assert(age ~= 0) --> assertion failed!
assert(age > 0, "log#1: Age must be positive.")
print("log #2: after error.")

--------------------------------------------
-- See Also: error, pcall, xpcall
