-- closures.lua

-- Create functions that retain state between calls.
local newCounter = function(n)
    local i = 0
    return function()
        i = i + 1
        return i <= n and i or nil
    end
end

-- Creates a separate counter with its own environment:
local c1 = newCounter(3)
local c2 = newCounter(5)

print(c1()) --> 1
print(c1()) --> 2
print(c2()) --> 1

print(c1()) --> 3
print(c2()) --> 2

print(c1()) --> nil
print(c2()) --> 3

print(c1()) --> nil
print(c2()) --> 4

print(c1()) --> nil
print(c2()) --> 5

print(c1()) --> nil
print(c2()) --> nil
