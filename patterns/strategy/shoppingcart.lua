local ShoppingCart = {
  items = {},
  payment = nil
}

function ShoppingCart:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function ShoppingCart:addItem(item)
  table.insert(self.items, item)
end

function ShoppingCart:setPayment(strategy)
  self.payment = strategy
end

function ShoppingCart:checkout()
  local totalAmount = 0
  for _, item in ipairs(self.items) do
    totalAmount = totalAmount + item.price
  end
  return self.payment:pay(totalAmount)
end

return ShoppingCart
