-- observer.lua

--------------------------------------------------------------------------------
-- #1.  Define the Subject Class

Subject = {
  observers = {}
}

function Subject:new(instance)
  instance = instance or {}
  self.__index = self
  return setmetatable(instance, self)
end

function Subject:attach(observer)
  table.insert(self.observers, observer)
end

function Subject:detach(observer)
  for i, obs in ipairs(self.observers) do
    if obs.id == observer.id then
      table.remove(self.observers, i)
      break
    end
  end
end

function Subject:notify()
  for _, observer in ipairs(self.observers) do
    observer:update(self.state)
  end
end

function Subject:setState(state)
  self.state = state
  self:notify()
end

function Subject:getState()
  return self.state
end

--------------------------------------------------------------------------------
-- #2.  Define the Observer Class

Observer = {
  id = 0
}

function Observer:new(instance)
  instance = instance or {}
  self.__index = self
  instance.subject:attach(instance)
  instance.id = self.id
  self.id = self.id + 1
  return setmetatable(instance, self)
end

function Observer:update(state)
  print("Observer " .. self.id .. " updated with state: " .. state)
end

--------------------------------------------------------------------------------
-- #3.  Demonstrate the Observer Pattern:

local weatherStation = Subject:new {}
local display1 = Observer:new({ subject = weatherStation })
local display2 = Observer:new({ subject = weatherStation })

local log = "temperature: %.2f, humidity: %.2f"
weatherStation:setState(log:format(23.9, 53))
weatherStation:setState(log:format(25, 55.3))
weatherStation:detach(display1)
weatherStation:setState(log:format(24, 45))

--------------------------------------------------------------------------------
