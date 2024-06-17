local ShoppingCart = require "shoppingcart"
local CreditCard = require "creditcard"
local PayPal = require "paypal"

local function main()
  -- Instantiates a ShoppingCart:
  local sc = ShoppingCart:new()

  -- Adds items to the cart:
  sc:addItem({ name = "Item1", price = 50 })
  sc:addItem({ name = "Item2", price = 50 })

  -- Sets the payment strategy to CreditCard:
  sc:setPayment(CreditCard:new {
    cardNumber = "1234 5678 9876 5432",
    expiryDate = "01/25",
    cvv = "456"
  })
  assert(sc:checkout() == "CreditCard paid $100.00")

  -- Changes the payment strategy to PayPal:
  sc:setPayment(PayPal:new {
    email = "jhon@exemple.com",
    password = "asdf1234"
  })
  assert(sc:checkout() == "PayPal paid $100.10")
end

main()
