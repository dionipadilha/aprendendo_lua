-- factory.lua

-- building complex objects with interchangeable parts.

--------------------------------------------------------------------------------
-- #1.Factory:

local Factory = {}

function Factory:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

--------------------------------------------------------------------------------
-- #2. Chassis:

-- Chassis Factory:
local FactoryChassis = Factory:new {}

function FactoryChassis:hold()
  error("This method should be overridden")
end

-- Chassis Type #1:
local chassisType_1 = FactoryChassis:new {}

function chassisType_1:hold()
  return "ChassisType_1 ok"
end

-- Chassis Type #2:
local chassisType_2 = FactoryChassis:new {}

function chassisType_2:hold()
  return "ChassisType_2 ok"
end

--------------------------------------------------------------------------------
-- #3. Engine:

-- Engine Factory:
local FactoryEngine = Factory:new {}

function FactoryEngine:start()
  error("This method should be overridden")
end

-- Engine Type #1:
local engineType_1 = FactoryEngine:new {}

function engineType_1:start()
  return "EngineType_1 is roaring"
end

-- Engine Type #2:
local engineType_2 = FactoryEngine:new {}

function engineType_2:start()
  return "EngineType_2 is roaring"
end

--------------------------------------------------------------------------------
-- #4. Transmission:

-- Transmission Factory:
local FactoryTransmission = Factory:new {}

function FactoryTransmission:shift()
  error("This method should be overridden")
end

-- Transmission Type #1:
local transmissionType_1 = FactoryTransmission:new {}

function transmissionType_1:shift()
  return "TransmissionType_1 is shifting"
end

-- Transmission Type #2:
local transmissionType_2 = FactoryTransmission:new {}

function transmissionType_2:shift()
  return "TransmissionType_2 is shifting"
end

--------------------------------------------------------------------------------
-- #5. Wheel:

-- Wheel Factory:
local FactoryWheel = Factory:new {}

function FactoryWheel:spin()
  error("This method should be overridden")
end

-- Wheel Type #1:
local wheelType_1 = FactoryWheel:new {}

function wheelType_1:spin()
  return "WheelType_1 is spinning"
end

-- Wheel Type #2:
local wheelType_2 = FactoryWheel:new {}

function wheelType_2:spin()
  return "WheelType_2 is spinning"
end

--------------------------------------------------------------------------------
-- #6. Car Assembly:

-- Car Factory:
local FactoryCar = Factory:new {}

function FactoryCar:check()
  error("This method should be overridden")
end

function FactoryCar:start()
  local status, result = pcall(self.check, self)
  print("self.check: ", status, result)
end

function FactoryCar:drive(pilot)
  print("Car is driving by: " .. pilot)
end

--------------------------------------------------------------------------------
-- Car Type #1

local Ford = FactoryCar:new {
  chassis = chassisType_1:new {},
  engine = engineType_1:new {},
  transmission = transmissionType_1:new {},
  wheel = wheelType_1:new {}
}

function Ford:check()
  assert(self.chassis and self.engine and self.transmission and self.wheel)
  assert(self.chassis:hold() == "ChassisType_1 ok")
  assert(self.engine:start() == "EngineType_1 is roaring")
  assert(self.transmission:shift() == "TransmissionType_1 is shifting")
  assert(self.wheel:spin() == "WheelType_1 is spinning")
  return "All components are functional"
end

--------------------------------------------------------------------------------
-- Car Type #2

local Tesla = FactoryCar:new {
  chassis = chassisType_2:new {},
  engine = engineType_2:new {},
  transmission = transmissionType_2:new {},
  wheel = wheelType_2:new {}
}

function Tesla:check()
  assert(self.chassis and self.engine and self.transmission and self.wheel)
  assert(self.chassis:hold() == "ChassisType_2 ok")
  assert(self.engine:start() == "EngineType_2 is roaring")
  assert(self.transmission:shift() == "TransmissionType_2 is shifting")
  assert(self.wheel:spin() == "WheelType_2 is spinning")
  return "All components are functional"
end

--------------------------------------------------------------------------------
-- #7. Testing the Cars:

Ford:start()       --> self.check: 	true	All components are functional
Ford:drive("ana")  --> Car is driving: ana

Tesla:start()      --> self.check: 	true	All components are functional
Tesla:drive("bob") --> Car is driving: bob
