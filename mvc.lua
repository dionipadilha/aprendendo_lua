--mvc.lua

-- Manages data and business logic:
local Model = {}

function Model:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function Model:setData(newData)
  assert(newData)
  self.data = newData
end

function Model:getData()
  return self.data
end

-- Handles the presentation layer and rendering of data:
local View = {}

function View:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function View:render(data)
  print("Data rendering: " .. data)
end

-- Updating the model and triggering view updates:
local Controller = {}

function Controller:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

function Controller:init(model, view)
  self.model = model
  self.view = view
end

function Controller:setData(data)
  self.model:setData(data)
  self.view:render(data)
end

function Controller:getData()
  return self.model:getData()
end

-- Example usage: Integrate the MVC components

-- Create instances of the model, view, and controller:
local controller = Controller:new {
  model = Model:new {},
  view = View:new {}
}

-- Set up the model with initial data:
controller:setData("Initial data") --> Data rendering: Initial data
assert(controller:getData() == "Initial data")

-- Update the model with new data:
controller:setData("Changed data") --> Data rendering: Changed data
assert(controller:getData() == "Changed data")
