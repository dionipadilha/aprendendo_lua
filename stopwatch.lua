-- Stopwatch class definition
local Stopwatch = {}

function Stopwatch:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function Stopwatch:start()
  self.initial = os.clock()
  return self.initial
end

function Stopwatch:stop()
  self.final = os.clock()
  return self.final
end

function Stopwatch:_diff()
  return self.final - self.initial
end

function Stopwatch:log()
  local elapsedTime = self:_diff()
  return string.format("elapsed time: %.5f seconds.", elapsedTime)
end

function Stopwatch:reset()
  self.initial = 0
  self.final = 0
  return true
end

-- Example usage:

local function main()
  -- Delay utility function
  local function busyDelay(n)
    assert(type(n) == "number" and n > 0, "Delay duration must be positive.")
    local start_time = os.clock()
    while os.clock() - start_time < n do
      -- wait
    end
  end

  -- Create an instance of the stopwatch:
  local myStopwatch = Stopwatch:new {
    initial = 0,
    final = 0
  }

  -- Use the stopwatch to time the delay function
  local start = myStopwatch:start()
  busyDelay(3)
  local stop = myStopwatch:stop()

  -- Print results
  print("start: ", start)
  print("stop: ", stop)
  print(myStopwatch:log())

  -- Reset the stopwatch
  myStopwatch:reset()
  assert(myStopwatch:log() == "elapsed time: 0.00000 seconds.")
end

main()
