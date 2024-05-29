-- dip.lua

-- Dependency Inversion Principle:
-- Depend on abstractions, not on concretions.

-- #1. Abstraction Interface:
local Logger = {}

function Logger:new(instance)
  self.__index = self
  instance = instance or {}
  return setmetatable(instance, self)
end

function Logger:log(message)
  error("This method should be overridden")
end

-- #2. Concrete Implementations:
local FileLogger = Logger:new {}
function FileLogger:log(message)
  local file, err = io.open(self.filename, "a")
  assert(file, err)
  file:write(message .. "\n")
  file:close()
end

local ConsoleLogger = Logger:new {}
function ConsoleLogger:log(message)
  print(message)
end

-- High-Level Module:
Application = {}

function Application:new(instance)
  assert(instance.logger.log, "required: logger.log")
  self.__index = self
  return setmetatable(instance, self)
end

function Application:doWork()
  self.logger:log("working ...")
end

-- Usage Example:
local fileLogger = FileLogger:new { filename = "log.txt" }
local consoleLogger = ConsoleLogger:new {}

local app1 = Application:new { logger = fileLogger }
local app2 = Application:new { logger = consoleLogger }

app1:doWork() -- Logs to a file
app2:doWork() -- Logs to the console
