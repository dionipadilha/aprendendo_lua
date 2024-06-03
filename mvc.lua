--mvc.lua

-- Abstract Class:Handle object instantiation and inheritance.
local Class = {}

function Class:new(object)
  self.__index = self
  object = object or {}
  setmetatable(object, self)
  return object
end

-- Model: Manages data and business logic.
local Model = Class:new {
  data = nil
}

function Model:setData(newData)
  assert(
    type(newData) == "string" and newData ~= "",
    "data must be a non-empty string"
  )
  self.data = newData
end

function Model:getData()
  return self.data
end

-- View: Handles the presentation layer.
local View = Class:new {}

function View:render(data)
  print("Data rendering: " .. data)
end

-- Controller: Updating the model and triggering view updates.
local Controller = Class:new {
  model = {},
  view = {}
}

function Controller:setData(data)
  assert(
    type(data) == "string" and data ~= "",
    "data must be a non-empty string"
  )
  self.model:setData(data)
  self.view:render(data)
end

function Controller:getData()
  return self.model:getData()
end

-- Example usage: Integrate the MVC components.

local function main()
  -- Create instances of the model, view, and controller:
  local controller = Controller:new {
    model = Model:new {},
    view = View:new {}
  }

  -- Set up the model with initial data:
  controller:setData("#1 Initial data") --> Data rendering: Initial data
  assert(controller:getData() == "#1 Initial data")

  -- Update the model with new data:
  controller:setData("#2 Changed data") --> Data rendering: Changed data
  assert(controller:getData() == "#2 Changed data")

  return "MVC pattern is working as expected."
end

print(pcall(main)) --> true	MVC pattern is working as expected.
