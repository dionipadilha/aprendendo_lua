local function readOnly(t)
  return setmetatable({}, {
    __index = t,
    __newindex = function()
      error("attempt to update a read-only table", 2)
    end
  })
end

local days = readOnly { "Sunday", "Monday", "Tuesday" }

print(days[1])    --> Sunday
days[2] = "Noday" --> error: attempt to update a read-only table
