-- coroutines_lifecycle.lua

-- Creates a coroutine function:
local function doSomething()
  print("doSomething #1")
  coroutine.yield("yielding #1")
  print("doSomething #2")
  coroutine.yield("yielding #2")
  return "coroutine finish!"
end

-- Instantiation a coroutine object:
local co = coroutine.create(doSomething)
print(co)                   --> thread id
print(coroutine.status(co)) --> suspended

-- Resumes the coroutine until it's finished:
repeat
  local success, response = coroutine.resume(co)
  if not success then
    print("Error:", response)
    break
  end
  print(success, response)
until coroutine.status(co) == "dead"
