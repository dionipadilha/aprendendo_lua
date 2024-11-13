### LUA Anonymous Functions

- Directly calls an anonymous function with an argument:
```lua
local y = (function(x) return x + 1 end)(3)
assert(y == 4)
```

- Assigns an anonymous function to a variable:
```lua
local successor = function(x) return x + 1 end
assert(successor(3) == 4)
```

- Take multiple arguments:
```lua
local add = function(a, b) return a + b end
assert(add(2, 3) == 5)
```

- First-class functions:
```lua
local function multiplyBy(x)
  return function(y) return x * y end
end

local timesTwo = multiplyBy(2)
assert(timesTwo(3) == 6)

local timesFive = multiplyBy(5)
assert(timesFive(3) == 15)
```

- Higher-order functions:
```lua
local function apply(f, x)
  return f(x)
end

assert(apply(function(x) return x + 1 end, 3) == 4)
assert(apply(function(x) return x * 2 end, 3) == 6)
```

- Closures:
```lua
local function newCounter()
  local i = 0
  return function() i = i + 1 return i end
end

local count = newCounter()
assert(count() == 1)
assert(count() == 2)
assert(count() == 3)
-- ...
```
