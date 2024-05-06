------------------------------------------------
local module = {}

module.doSomething = function ()
  print("toast!")
end

return module

------------------------------------------------
local module = require "module"
module.doSomething() --> toast
