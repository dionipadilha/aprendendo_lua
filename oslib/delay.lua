-- delay.lua

-- Define a function:
local function delay(n)
  assert(n > 0)
  local start_time = os.clock()
  while os.clock() - start_time < n do
    -- nothing
  end
end
