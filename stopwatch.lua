--------------------------------------------------------------------------------
-- Stopwatch Implementation:

local IStopwatch = {}

function IStopwatch:new(contract)
  contract = contract or {}
  setmetatable(contract, self)
  self.__index = self
  return contract
end

function IStopwatch:start() error("Implementation by concrete class") end

function IStopwatch:stop() error("Implementation by concrete class") end

function IStopwatch:log() error("Implementation by concrete class") end

function IStopwatch:reset() error("Implementation by concrete class") end

--------------------------------------------------------------------------------
-- Concrete Stopwatch implementation
local Stopwatch = IStopwatch:new { startTime = 0, stopTime = 0, running = false }

function Stopwatch:start()
  self.running = true
  self.startTime = os.clock()
end

function Stopwatch:stop()
  self.stopTime = os.clock()
  self.running = false
end

function Stopwatch:log()
  local elapsedTime = 0
  if self.running then
    elapsedTime = os.clock() - self.startTime
    return "Stopwatch is running. Elapsed time: " .. elapsedTime .. " seconds."
  else
    elapsedTime = self.stopTime - self.startTime
    return "Stopwatch stopped. Elapsed time: " .. elapsedTime .. " seconds."
  end
end

function Stopwatch:reset()
  self.startTime = 0
  self.stopTime = 0
  self.running = false
end

--------------------------------------------------------------------------------
-- Stopwatch Testing:

-- Define a delay function to simulate a time-consuming task
local function busyDelay(seconds)
  assert(type(seconds) == "number" and seconds > 0, "Delay duration must be positive.")
  local start_time = os.clock()
  while os.clock() - start_time < seconds do
    -- busy wait
  end
end

-- Usage with dependency injection
local function test(stopwatch)
  stopwatch:start()

  -- Perform some timed operations
  print("#1 ...")
  busyDelay(1)
  print("#2 ...")
  busyDelay(1)
  print(stopwatch:log()) --> Stopwatch running. Elapsed time: x seconds.
  print("#3 ...")
  busyDelay(1)
  stopwatch:stop()

  -- Log stopwatch results
  print(stopwatch:log()) --> Stopwatch stopped. Elapsed time: y seconds.

  -- Reset the stopwatch
  stopwatch:reset()

  -- Log stopwatch results
  assert(stopwatch:log() == "Stopwatch stopped. Elapsed time: 0 seconds.")
end

-- Usage
local myStopwatch = Stopwatch:new()
test(myStopwatch)

--------------------------------------------------------------------------------
