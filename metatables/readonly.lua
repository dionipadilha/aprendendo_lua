local function readOnly(t)
  return setmetatable({}, {
    __index = t,
    __newindex = function()
      error("attempt to update a read-only table", 2)
    end
  })
end

local days = readOnly { "Sunday", "Monday", "Tuesday" }

print(days[1]) --> Sunday

-- Updating a read-only table raises an error; catch it with pcall:
local ok, err = pcall(function() days[2] = "Noday" end)
print(ok, err) --> false	readonly.lua: attempt to update a read-only table
