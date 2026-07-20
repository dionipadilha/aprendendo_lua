-- run from within the json/ directory: lua main.lua
local json_decode = require "json_decode"
local json_encode = require "json_encode"

local JSON = {}

function JSON:decode(value)
  return json_decode(value)
end

function JSON:encode(value)
  return json_encode(value)
end

return JSON
