local Payment = require "payment"

local PayPal = Payment:new {
  email = "undefined@email.com",
  password = "1234"
}

function PayPal:pay(amount)
  local transaction = 0.10
  amount = amount or 0
  local total = amount + transaction
  local result = string.format("PayPal paid $%.2f", total)
  return result
end

return PayPal
