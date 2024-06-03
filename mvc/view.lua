-- View: Handles the presentation layer.

local Class = require "common"

local View = Class:new {}

function View:render(data)
  print("Data rendering: " .. data)
end

return View
