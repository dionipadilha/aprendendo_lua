-- logger.lua

local Class = require "class"

local Logger = Class:new {

  logs = {},

  log = function(self, message)
    table.insert(self.logs, message)
  end,

  printLogs = function(self)
    for _, log in ipairs(self.logs) do
      print(log)
    end
  end
}

--[[ tests
local logger = Logger:new {}
assert(logger.logs ~= nil)

logger:log("x")
assert(logger.logs[1] == "x")

logger:log("y")
assert(logger.logs[2] == "y")

logger:printLogs() --> x, y
]]


return Logger
