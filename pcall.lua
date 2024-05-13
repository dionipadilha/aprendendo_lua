-- pcall.lua

--------------------------------------------
-- Details:

-- Execute a function within a safe environment.

-- Syntax: pcall(func, arg1, arg2, ...)
-- Returns: try, result1, result2, ...

--------------------------------------------
-- Basic examples:

local function riskyDivision(x, y)
    assert(y ~= 0, "Division by zero")
    return x / y
end

print("#1:", pcall(riskyDivision, 8, 4))
print("#2:", pcall(riskyDivision, 8, 0))

print("#3:", "after riskyDivision #1 and #2.")

--------------------------------------------
-- See Also: error, assert, xpcall
