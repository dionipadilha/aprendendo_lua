local ShoppingCart = {}

function ShoppingCart:new()
  local cart = {}
  setmetatable(cart, self)
  self.__index = self
  return cart
end

function ShoppingCart:setPayment(classPay)
  self.class = classPay
  return self
end

function ShoppingCart:checkout(amount)
  return self.class:pay(amount)
end

return ShoppingCart
