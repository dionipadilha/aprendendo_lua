-- types.lua

-- number:
print(type(42))   --> number
print(type(3.14)) --> number

-- string:
print(type("a"))   --> string
print(type("bob")) --> string

-- boolean:
print(type(true))  --> boolean
print(type(false)) --> boolean

-- table:
print(type({ "bob", 42 }))              --> table
print(type({ name = "bob", age = 42 })) --> table

-- nil:
print(type(nil))   --> nil
print(true or nil) --> true

-- function:
print(type(print))     --> function
local quadratic = function(x) return x ^ 2 end
print(type(quadratic)) --> function

-- thread
print(type(coroutine.create(quadratic))) --> thread
