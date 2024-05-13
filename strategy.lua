-- strategy.lua

--------------------------------------------------------------------------------
-- payment.lua

local PaymentStrategy = {}

function PaymentStrategy:new(strategy)
  strategy = strategy or {}
  setmetatable(strategy, self)
  self.__index = self
  return strategy
end

function PaymentStrategy:pay()
  return error("pay method must be implemented by concrete strategies")
end

-- return PaymentStrategy

--------------------------------------------------------------------------------
-- creditcard.lua

-- local PaymentStrategy = require "payment.lua"

local CreditCard = PaymentStrategy:new {
  cardNumber = "0000 0000 0000 0000",
  expiryDate = "00/00",
  cvv = "000"
}

function CreditCard:pay(amount)
  amount = amount or 0
  local result = string.format("CreditCard paid $%.2f", amount)
  return result
end

-- return CreditCard

--------------------------------------------------------------------------------
-- paypal.lua

-- local PaymentStrategy = require "payment.lua"

local PayPal = PaymentStrategy:new {
  email = "undefined@email.com",
  password = "1234"
}

function PayPal:pay(amount, transaction)
  transaction = transaction or 0.10
  amount = amount or 0
  local total = amount + transaction
  local result = string.format("PayPal paid $%.2f", total)
  return result
end

-- return PayPal

--------------------------------------------------------------------------------
-- shoppingcart.lua

local ShoppingCart = {}

function ShoppingCart:new()
  local cart = {}
  setmetatable(cart, self)
  self.__index = self
  return cart
end

function ShoppingCart:setPayment(strategy)
  self.paymentStrategy = strategy
  return true
end

function ShoppingCart:checkout(amount)
  return self.paymentStrategy:pay(amount)
end

-- return ShoppingCart

--------------------------------------------------------------------------------
-- strategy_test.lua

-- local ShoppingCart = require "shoppingcart.lua"
-- local CreditCard = require "creditcard.lua"
-- local PayPal = require "paypal.lua"

local TestUnit = {}

function TestUnit.kickoff()
  -- Instantiates a ShoppingCart:
  local sc = ShoppingCart:new()

  -- Sets the payment strategy to CreditCard:
  sc:setPayment(CreditCard)
  assert(sc:checkout(100) == "CreditCard paid $100.00")

  -- Changes the payment strategy to PayPal:
  sc:setPayment(PayPal)
  assert(sc:checkout(100) == "PayPal paid $100.10")
end

TestUnit.kickoff()

--------------------------------------------------------------------------------
