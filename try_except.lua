local function divideBy(a, b)
  assert(b ~= 0, "myerror")
  return a / b
end

local function errorHandler(errorMsg)
  print(errorMsg)
end

-- try:
local success, result = pcall(divideBy, 6, 0)

-- except:
if not success then errorHandler(result) end

-- finally
print("after pcall")
