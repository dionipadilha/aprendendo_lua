local IPayment = require "ipayment"

-- class CreditCard implements IPayment properties
local CreditCard = {
  class = "CreditCard",

  -- implements IPayment properties
  methodData = "CreditCard",
  date = "",

  -- extend CreditCard properties
  cardNumber = "0000 0000 0000 0000",
  expiryDate = "00/00",
  cvv = "000"
}

-- CreditCard Constructor
function CreditCard:new(card)
  card = card or {}
  setmetatable(card, self)
  self.__index = self
  return card
end

-- implements IPayment method: canMakePayment
function CreditCard:canMakePayment()
  local log = "fail: Payment cannot be made"
  local response = true -- #simulation
  assert(response, log)
  return self
end

-- implements IPayment method: processPayment
function CreditCard:processPayment(amount)
  local log = "ProcessPayment: Payment processing failed"
  local response = true -- #simulation
  assert(response, log)
  return response
end

-- implements IPayment method: pay
function CreditCard:pay(amount)
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

-- implements IPayment contract
function CreditCard:implements(interface)
  local log = "\nfail: class CreditCard implements IPayment %s"
  for propertyName, propertyType in pairs(interface) do
    assert(
      propertyType == type(self[propertyName]),
      log:format(propertyName)
    )
  end
  return true
end

-- signs the IPayment contract
assert(CreditCard:implements(IPayment))

return CreditCard
