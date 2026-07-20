-- creates a coroutine function using coroutine.wrap():
local doSomething = coroutine.wrap(function()
  print("doSomething #1")
  coroutine.yield("yielding #1")
  print("doSomething #2")
  coroutine.yield("yielding #2")
  return "coroutine finish!"
end)


-- resumes the wraped coroutine:
local response = doSomething() --> doSomething #1
print(response)                --> yielding #1
response = doSomething()       --> doSomething #2
print(response)                --> yielding #2
response = doSomething()       -->
print(response)                --> coroutine finish!
print(pcall(doSomething))      --> false cannot resume dead coroutine
