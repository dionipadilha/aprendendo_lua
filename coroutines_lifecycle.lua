-- coroutines_lifecycle.lua

-- Creates a coroutine with a lambda function:
local co = coroutine.create(function()
  -- coroutine step #1:
  print("doSomething #1")
  coroutine.yield("yielding #1")

  -- coroutine step #2:
  print("doSomething #2")
  coroutine.yield("yielding #2")

  -- coroutine finish:
  print("coroutine finish!")
end)
print(co) --> thread id

-- Checking status before resume:
print(coroutine.status(co)) --> suspended

-- Starts the coroutine and get the yielded value:
local status, response = coroutine.resume(co) --> doSomething #1
print(status, response)                       --> true, yielding #1
print(coroutine.status(co))                   --> suspended

-- Restarting the coroutine and get the second yielded value:
local status, response = coroutine.resume(co) --> doSomething #2
print(status, response)                       --> true, yielding #2
print(coroutine.status(co))                   --> suspended

-- Checking status after the last yielded value::
status, response = coroutine.resume(co) --> coroutine finish!
print(status, response)                 --> true, nil
print(coroutine.status(co))             --> dead

-- Trying to resume a dead coroutine:
status, response = coroutine.resume(co)
print(status, response)     --> false	cannot resume dead coroutine
print(coroutine.status(co)) --> dead
