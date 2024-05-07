-- coroutine_args.lua

-- Creates a coroutine function:
local function doSomething(initialData)
  local newData = coroutine.yield("y#1: " .. initialData)
  coroutine.yield("y#2: " .. newData)
end

-- Creates a coroutine object:
local co = coroutine.create(doSomething)

-- Resumes the coroutine:
local success, response = coroutine.resume(co, "a")
print(success, response) --> true	y#1: a

success, response = coroutine.resume(co, "b")
print(success, response) --> true	y#2: b

success, response = coroutine.resume(co)
print(success, response) --> false nil

success, response = coroutine.resume(co)
print(success, response) --> false cannot resume dead coroutine
