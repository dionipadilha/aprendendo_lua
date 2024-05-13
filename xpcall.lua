local function divideBy(a, b)
  assert(b ~= 0, "myerror")
  return a / b
end

local function errorHandler(errorMsg)
  -- except:
  print(errorMsg)
end

-- try:
local success, result = xpcall(divideBy, errorHandler, 6, 0)

-- finally
print("after pcall")
