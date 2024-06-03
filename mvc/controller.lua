-- Controller: Manages the interaction between the Model and the View.

local Class = require "common"

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

return Controller
