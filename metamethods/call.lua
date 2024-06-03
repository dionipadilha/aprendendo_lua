-- call.lua

-----------------------------------------------------------------------------
-- __call:
-- lets a table be used as a function

-- #1. Create a table like a function:
local plural = setmetatable({}, {
  __call = function(self, ...)
    for _, word in ipairs({ ... }) do print(word .. "s") end
  end
})

-- #2. Call the table like a function:
print("Table is called like a function!")
plural("cat", "dog") --> cats, dogs
-----------------------------------------------------------------------------
-- Applying the concept:

-- #1. Define a transformation table with various methods
local transformations = {
  plural = function(word) return word .. "s" end,
  capitalize = function(word) return word:sub(1, 1):upper() .. word:sub(2) end,
  reverse = function(word) return word:reverse() end
}

-- #2. Create a table like a function:
local transformer = setmetatable({}, {
  __call = function(self, action, ...)
    if transformations[action] then
      for _, word in ipairs({ ... }) do
        print(transformations[action](word))
      end
    else
      print("Unknown action: " .. action)
    end
  end
})

--#3. Call the table like a function:
print("Table is called like a function!")
transformer("plural", "cat", "dog")
transformer("capitalize", "cat", "dog")
transformer("reverse", "cat", "dog")
transformer("unknown", "cat", "dog")
-----------------------------------------------------------------------------
