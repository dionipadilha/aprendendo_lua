-- Model: Manages data business logic.

local Class = require "common"

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

return Model
