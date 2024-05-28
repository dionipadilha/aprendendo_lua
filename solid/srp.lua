--srp.lua

-- Single Responsibility Principle:
-- Each function has a clear and specific responsibility.

local SRP = {}

function SRP.validateRequest(request)
  -- validation logic
end

function SRP.processRequest(request)
  -- validation logic
end

function SRP.logRequest(request)
  -- logging logic
end

function SRP:handleRequest(request)
  self.validateRequest(request)
  self.processRequest(request)
  self.logRequest(request)
end

return SRP
