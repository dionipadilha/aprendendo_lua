-- Define the decorator function
local function my_decorator(func)
  return function()
    print("Something happens before the function is called.")
    func()
    print("Something happens after the function is called.")
  end
end

-- Define the function to be decorated
local function say_hello()
  print("Hello!")
end

-- Apply the decorator
say_hello = my_decorator(say_hello)

-- Call the decorated function
say_hello()
