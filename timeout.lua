-- setTimeout function for Lua coroutines

local function setTimeout(callback, delaySeconds)
  local startTime = os.clock()
  local function checkTime()
      if os.clock() - startTime >= delaySeconds then
          callback()
          return true
      else
          return false
      end
  end

  repeat
      coroutine.yield()
  until checkTime()
end

-- Usage
local co = coroutine.create(function()
  setTimeout(function() print("Hello, World!") end, 1) -- 1 second delay
end)

-- This loop is required to keep the coroutine running
while coroutine.status(co) ~= 'dead' do
  coroutine.resume(co)
end
