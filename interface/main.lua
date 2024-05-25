local ShoppingCart = require "shoppingcart"
local CreditCard = require "creditcard"
local Pix = require "pix"

local cart = ShoppingCart:new()
local creditCard = CreditCard:new {}
local pix = Pix:new {}

local function main()
  print(cart:setPayment(creditCard):checkout(100)) --> true
  print(cart:setPayment(pix):checkout(50))         --> true
  --cart:setPayment(Pix):checkout(-50)             --> fail
end

main()
