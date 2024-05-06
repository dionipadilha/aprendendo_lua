-- coroutines_lifecycle.lua

-- Creates a coroutine function:
local function doSomething()
  print("doSomething #1")
  coroutine.yield("yielding #1")
  print("doSomething #2")
  coroutine.yield("yielding #2")
  print("coroutine finish!")
end

-- Creates a coroutine with a coroutine function:
local co = coroutine.create(doSomething)
print(co)                   --> thread id
print(coroutine.status(co)) --> suspended

-- Resumes the coroutine until it's finished:
repeat
  local sucess, response = coroutine.resume(co)
  print(sucess, response)
until coroutine.status(co) == "dead"

print(coroutine.status(co)) --> dead
