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

-- Define a recursive factorial function:
local function doSomething()
  os.execute("sleep 10") -- TERMINAR
  return "toast!"
end

-- Stopwatch the recursive factorial function:
stopwatch:start()
print(doSomething())
stopwatch:stop()
print(string.format("elapsed time: %.5f seconds.", stopwatch:diff()))
