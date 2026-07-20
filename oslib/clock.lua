-- os.clock
local function delay(interval)
  local stop = os.clock() + interval
  while os.clock() < stop do end
end

local start = os.clock()
delay(5)            -- seconds
local stop = os.clock()
print(stop - start) --> 5.000007
