--------------------------------------------------------------------------------
-- interface.lua

local IPayment = {

  -- contract properties:
  date = "string",
  methodData = "string",

  -- contract methods:
  new = "function", -- constructor
  canMakePayment = "function",
  processPayment = "function",
  pay = "function"
}

return IPayment

--------------------------------------------------------------------------------
-- class.lua

local IPayment = require "interface"

-- Define the CreditCard class with default properties
local CreditCard = {
  class = "CreditCard",
  methodData = "CreditCard",
  date = "undefined",
  cardNumber = "0000 0000 0000 0000",
  expiryDate = "00/00",
  cvv = "000"
}

-- Constructor method for creating new instances of CreditCard
function CreditCard:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

-- Method to check if the card can make a payment
function CreditCard:canMakePayment()
  local log = "CanMakePayment: Payment cannot be made"
  -- simulation: modify this to simulate different conditions
  local response = true
  assert(response, log)
  return self
end

-- Method to process a payment
function CreditCard:processPayment(amount)
  local log = "ProcessPayment: Payment processing failed"
  -- simulation: modify this to simulate different conditions
  local response = true
  assert(response, log)
  return response
end

-- Method to handle the payment process
function CreditCard:pay(amount)
  local log = {
    "\nProcess payment: fail. Amount must be a non-negative number",
    "\nProcess payment: fail",
    "Process payment: success"
  }
  -- Ensure the amount is a non-negative number
  assert(type(amount) == "number" and amount >= 0, log[1])
  -- Check if payment can be made and then process it
  assert(self:canMakePayment():processPayment(amount), log[2])
  return true, log[3]
end

-- Method to check if the class implements the given interface
function CreditCard:implements(interface)
  local log = "\nfail: class CreditCard implements IPayment %s"
  for propertyName, propertyType in pairs(interface) do
    assert(
      propertyType == type(self[propertyName]),
      log:format(propertyName)
    )
  end
  return self
end

-- sign the contract
return CreditCard:implements(IPayment)
