local Payment = {}

function Payment:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function Payment:pay(amount)
  return error("pay method must be implemented by concrete classes")
end

return Payment
