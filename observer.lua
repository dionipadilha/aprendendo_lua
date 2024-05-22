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

local subject = Subject:new()
local observer1 = Observer:new({ subject = subject })
local observer2 = Observer:new({ subject = subject })

subject:setState("State 1")
subject:setState("State 2")

subject:detach(observer1)

subject:setState("State 3")

--------------------------------------------------------------------------------
