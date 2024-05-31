-- timesource.lua

-- Defines a time source interface:
local TimeSource = {
  now = function(self) error("\nMethod must be overridden.") end
}

-- Defines a time source constructor:
function TimeSource:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

-- TimeSource Implementation #1: os.clock
local timeSource1 = TimeSource:new {
  now = function(self) return os.clock() end
}

-- TimeSource Implementation #2: ntp simulation
local function simulateNtpSync()
  return os.clock()
end

local timeSource2 = TimeSource:new {
  now = function(self) return simulateNtpSync() end
}

-- Use different time source implementations:
local timeSources = { timeSource1, timeSource2 }
for _, timeSource in ipairs(timeSources) do
  print("Current Time: ", timeSource:now())
end
