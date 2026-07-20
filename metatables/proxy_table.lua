-- proxy_table.lua

-------------------------------------------------------------
-- Assign standard table:

local table = {}

-- Trying to assign a value to a key that doesn't exist:
table["foo"] = "bar"
print(table["foo"]) --> bar

-------------------------------------------------------------
--  Intercepting and handling assignments:

local new_table = {}
local proxy = {
  __newindex = function(t, k, v)
    -- rawset(t, k, v)
    print("update denied: " .. tostring(k) .. " to " .. tostring(v))
  end
}
setmetatable(new_table, proxy)

-- Trying to assign a value to a key that doesn't exist:
new_table["foo"] = "bar" --> update denied: foo to bar
print(new_table["foo"])  --> nil

-------------------------------------------------------------
