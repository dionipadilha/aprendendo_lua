-- ocp.lua

-- Open-Closed Principle:
-- Entities should be open for extension but closed for modification.

-- #1. Abstract Customer Class:
local Customer = {
  getDiscount = function(self) return error("not implemented") end
}

function Customer:new(customerType)
  self.__index = self
  customerType = customerType or {}
  return setmetatable(customerType, self)
end

-- #2. Concrete Customer Types:
local RegularCustomer = Customer:new {
  getDiscount = function(self) return 0.1 end
}

local PremiumCustomer = Customer:new {
  getDiscount = function(self) return 0.2 end
}

-- #3. Generic Discount Calculation:
local pay = {}

function pay.calculateDiscount(customer)
  assert(customer.getDiscount, "Invalid customer object.")
  return customer:getDiscount()
end

local Roberto = RegularCustomer:new {}
local Paulo = PremiumCustomer:new {}

assert(pay.calculateDiscount(Roberto) == 0.1)
assert(pay.calculateDiscount(Paulo) == 0.2)
