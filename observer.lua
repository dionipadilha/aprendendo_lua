-- observer.lua

--------------------------------------------------------------------------------
local Class = {
  new = function(self, object)
    object = object or {}
    self.__index = self
    return setmetatable(object, self)
  end
}

--------------------------------------------------------------------------------
local Subject = Class:new {
  observers = {}
}

function Subject:attach(newObservers)
  for _, newObserver in ipairs(newObservers) do
    table.insert(self.observers, newObserver)
  end
end

function Subject:notify(...)
  for _, observer in ipairs(self.observers) do
    observer:update(...)
  end
end

--------------------------------------------------------------------------------
local Observer = Class:new {}

function Observer:update(...)
  print(..., self.id)
end

--------------------------------------------------------------------------------
-- Example:

-- create observers:
local display1 = Observer:new { id = "display #1" }
local display2 = Observer:new { id = "display #2" }
local display3 = Observer:new { id = "display #3" }

-- create subject:
local weatherStation1 = Subject:new {
  observers = {
    display1,
    display2
  }
}

-- create other subject:
local weatherStation2 = Subject:new {
  observers = {
    display2,
    display3
  }
}

weatherStation1:notify("weatherStation #1 calling")
--> weatherStation #1 calling	display #1
--> weatherStation #1 calling	display #2

weatherStation2:notify("weatherStation #2 calling")
--> weatherStation #2 calling	display #2
--> weatherStation #2 calling	display #3
--------------------------------------------------------------------------------
