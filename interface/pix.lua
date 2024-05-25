local IPayment = require "ipayment"

-- Pix class definition
local Pix = {
  class = "Pix",

  -- implements IPayment properties
  methodData = "Pix",
  date = "",

  -- extend Pix properties
  keyType = "CPF", -- CPF or CNPJ
  key = "000.000.000-00"
}

-- Pix Constructor
function Pix:new(pix)
  pix = pix or {}
  setmetatable(pix, self)
  self.__index = self
  return pix
end

-- IPayment method: canMakePayment
function Pix:canMakePayment()
  local log = "fail: Payment cannot be made"
  local response = true -- #simulation
  assert(response, log)
  return self
end

-- IPayment method: processPayment
function Pix:processPayment(amount)
  local log = "ProcessPayment: Payment processing failed"
  local response = true -- -- #simulation
  assert(response, log)
  return response
end

-- IPayment method: pay
function Pix:pay(amount)
  local log = {
    "\nfail: Amount must be a non-negative number",
    "\nProcess payment: fail",
    "Process payment: success"
  }
  -- Ensure the amount is a non-negative number
  assert(type(amount) == "number" and amount >= 0, log[1])
  -- Check if payment can be made and then process it
  assert(self:canMakePayment():processPayment(amount), log[2])
  return true, log[3], amount
end

-- Method to check implementation of IPayment interface
function Pix:implements(interface)
  local log = "\nfail: class Pix implements IPayment %s"
  for propertyName, propertyType in pairs(interface) do
    assert(
      propertyType == type(self[propertyName]),
      log:format(propertyName)
    )
  end
  return true
end

-- Sign the IPayment contract
assert(Pix:implements(IPayment))

return Pix
