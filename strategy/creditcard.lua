local Payment = require "payment"

local CreditCard = Payment:new {
  cardNumber = "0000 0000 0000 0000",
  expiryDate = "00/00",
  cvv = "000"
}

function CreditCard:pay(amount)
  amount = amount or 0
  local result = string.format("CreditCard paid $%.2f", amount)
  return result
end

return CreditCard
