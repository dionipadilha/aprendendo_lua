-- coroutine_args.lua

-- Creates a coroutine function:
local function doSomething(initialData)
  local newData = coroutine.yield("initialData: " .. initialData)
  coroutine.yield("newData: " .. tostring(newData))
  return initialData .. tostring(newData)
end

-- Creates a coroutine object:
local co = coroutine.create(doSomething)
print(coroutine.status(co)) --> suspended

-- Resumes the coroutine with an initial value:
local success, response = coroutine.resume(co, "bob")
print(success, response, coroutine.status(co)) --> initialData: bob suspended

-- Resumes the coroutine with a new value:
success, response = coroutine.resume(co, 42)
print(success, response, coroutine.status(co)) --> newData: 42 suspended

-- Resumes the coroutine without value:
success, response = coroutine.resume(co)
print(success, response, coroutine.status(co)) --> false bob42 dead
