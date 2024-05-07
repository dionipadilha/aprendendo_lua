-- Define a stopwatch:
local stopwatch = {}

function stopwatch.start(self)
  self.initial = os.clock()
  return self.initial
end

function stopwatch.stop(self)
  self.final = os.clock()
  return self.final
end

function stopwatch.diff(self)
  return self.final - self.initial
end

-- Define a function:
local function delay(n)
  assert(n > 0)
  local start_time = os.clock()
  while os.clock() - start_time < n do
    -- nothing
  end
end

-- Create an instance of the stopwatch:
local myStopwatch = setmetatable({}, { __index = stopwatch })

-- Stopwatch the recursive factorial function:
print("start: ", myStopwatch:start())
delay(3)
print("stop: ", myStopwatch:stop())
print(string.format("elapsed time: %.5f seconds.", myStopwatch:diff()))
