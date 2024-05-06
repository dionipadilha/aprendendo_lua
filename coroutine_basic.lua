-- coroutine_basic.lua

-- Create a new coroutine object:
local function doSomething() print("toast!") end
local co = coroutine.create(doSomething)

-- Check coroutine status:
print(co)                   --> thread: identifier
print(coroutine.status(co)) --> suspended

-- Starts the coroutine's execution:
coroutine.resume(co)        --> toast!

-- Checking status after resume:
print(coroutine.status(co)) --> dead

-- Starts the coroutine's execution:
coroutine.resume(co)        --> (nothing printed)
print(coroutine.status(co)) --> dead
