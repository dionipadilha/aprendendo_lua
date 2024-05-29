-- dip.lua

-- Dependency Inversion Principle:
-- Depend on abstractions, not on concretions.

-- Abstraction
local Database = {}

function Database:connect()
  error("This method should be overridden")
end

-- Low-level module
local MySQLDatabase = Database:new()

function MySQLDatabase:connect()
  print("Connecting to MySQL database")
end

-- High-level module
local PasswordReminder = {}

function PasswordReminder:new(database)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  self.database = database
  return o
end

function PasswordReminder:connect()
  self.database:connect()
end

-- Test
local mySQL = MySQLDatabase:new()
local reminder = PasswordReminder:new(mySQL)
reminder:connect()
