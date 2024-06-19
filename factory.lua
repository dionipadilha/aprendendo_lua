-- factory.lua

-- building complex objects with interchangeable parts.

--------------------------------------------------------------------------------
-- Factory Base Class:

local Factory = {}

function Factory:new(instance)
  instance = instance or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

--------------------------------------------------------------------------------
-- Chassis Factory and Types:

local ChassisFactory = Factory:new {}

function ChassisFactory:hold()
  error("This method should be overridden")
end

local chassisType1 = ChassisFactory:new {}

function chassisType1:hold()
  return "ChassisType1 ok"
end

local chassisType2 = ChassisFactory:new {}

function chassisType2:hold()
  return "ChassisType2 ok"
end

--------------------------------------------------------------------------------
-- Engine Factory and Types:

local EngineFactory = Factory:new {}

function EngineFactory:start()
  error("This method should be overridden")
end

local engineType1 = EngineFactory:new {}

function engineType1:start()
  return "EngineType1 is roaring"
end

local engineType2 = EngineFactory:new {}

function engineType2:start()
  return "EngineType2 is roaring"
end

--------------------------------------------------------------------------------
-- Transmission Factory and Types:

local TransmissionFactory = Factory:new {}

function TransmissionFactory:shift()
  error("This method should be overridden")
end

local transmissionType1 = TransmissionFactory:new {}

function transmissionType1:shift()
  return "TransmissionType1 is shifting"
end

local transmissionType2 = TransmissionFactory:new {}

function transmissionType2:shift()
  return "TransmissionType2 is shifting"
end

--------------------------------------------------------------------------------
-- Wheel Factory and Types:

local WheelFactory = Factory:new {}

function WheelFactory:spin()
  error("This method should be overridden")
end

local wheelType1 = WheelFactory:new {}

function wheelType1:spin()
  return "WheelType1 is spinning"
end

local wheelType2 = WheelFactory:new {}

function wheelType2:spin()
  return "WheelType2 is spinning"
end

--------------------------------------------------------------------------------
-- Car Assembly and Types:

local CarFactory = Factory:new {}

function CarFactory:check()
  error("This method should be overridden")
end

function CarFactory:start()
  local status, result = pcall(self.check, self)
  print("self.check: ", status, result)
end

function CarFactory:drive(driver)
  print("Car is driving by: " .. driver)
end

--------------------------------------------------------------------------------
-- Ford Car Type:

local Ford = CarFactory:new {
  chassis = chassisType1:new {},
  engine = engineType1:new {},
  transmission = transmissionType1:new {},
  wheel = wheelType1:new {}
}

function Ford:check()
  assert(self.chassis and self.engine and self.transmission and self.wheel)
  assert(self.chassis:hold() == "ChassisType1 ok")
  assert(self.engine:start() == "EngineType1 is roaring")
  assert(self.transmission:shift() == "TransmissionType1 is shifting")
  assert(self.wheel:spin() == "WheelType1 is spinning")
  return "All components are functional"
end

--------------------------------------------------------------------------------
-- Tesla Car Type:

local Tesla = CarFactory:new {
  chassis = chassisType2:new {},
  engine = engineType2:new {},
  transmission = transmissionType2:new {},
  wheel = wheelType2:new {}
}

function Tesla:check()
  assert(self.chassis and self.engine and self.transmission and self.wheel)
  assert(self.chassis:hold() == "ChassisType2 ok")
  assert(self.engine:start() == "EngineType2 is roaring")
  assert(self.transmission:shift() == "TransmissionType2 is shifting")
  assert(self.wheel:spin() == "WheelType2 is spinning")
  return "All components are functional"
end

--------------------------------------------------------------------------------
-- Testing the Cars:

Ford:start()       --> self.check: 	true	All components are functional
Ford:drive("ana")  --> Car is driving: ana

Tesla:start()      --> self.check: 	true	All components are functional
Tesla:drive("bob") --> Car is driving: bob
