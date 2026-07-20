-- main.lua
-- Integrate the MVC components.

local Model = require "model"
local View = require "view"
local Controller = require "controller"

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
