-- factory.lua

-- building complex objects with interchangeable parts.

--------------------------------------------------------------------------------
-- #1.Factory:

local Factory = {}
function Factory:new(factory)
  factory = factory or {}
  self.__index = self
  return setmetatable(factory, self)
end

--------------------------------------------------------------------------------
-- #2. Chassis:

-- Chassis Factory:
local AbstractChassis = Factory:new {}
function AbstractChassis:hold()
  error("This method should be overridden")
end

-- Chassis Object #1:
local chassis_1 = AbstractChassis:new {}
function chassis_1:hold()
  return "Chassis_1 ok"
end

-- Chassis Object #2:
local chassis_2 = AbstractChassis:new {}
function chassis_2:hold()
  return "Chassis_2 ok"
end

--------------------------------------------------------------------------------
-- #3. Engine:

-- Engine Factory:
local AbstractEngine = Factory:new {}
function AbstractEngine:start()
  error("This method should be overridden")
end

-- Engine Object #1:
local engine_1 = AbstractEngine:new {}
function engine_1:start()
  return "Engine_1 is roaring"
end

-- Engine Object #2:
local engine_2 = AbstractEngine:new {}
function engine_2:start()
  return "Engine_2 is roaring"
end

--------------------------------------------------------------------------------
-- #4. Transmission:

-- Transmission Factory:
local AbstractTransmission = Factory:new {}
function AbstractTransmission:shift()
  error("This method should be overridden")
end

-- Transmission Object #1:
local transmission_1 = AbstractTransmission:new {}
function transmission_1:shift()
  return "Transmission_1 is shifting"
end

-- Transmission Object #2:
local transmission_2 = AbstractTransmission:new {}
function transmission_2:shift()
  return "Transmission_2 is shifting"
end

--------------------------------------------------------------------------------
-- #5. Wheel:

-- Wheel Factory:
local AbstractWheel = Factory:new {}
function AbstractWheel:spin()
  error("This method should be overridden")
end

-- Wheel Object #1:
local wheel_1 = AbstractWheel:new {}
function wheel_1:spin()
  return "Wheel_1 is spinning"
end

-- Wheel Object #2:
local wheel_2 = AbstractWheel:new {}
function wheel_2:spin()
  return "Wheel_2 is spinning"
end

--------------------------------------------------------------------------------
-- #6. Car Assembly:

-- Car Factory:
local AbstractCar = Factory:new {}

function AbstractCar:check()
  error("This method should be overridden")
end

function AbstractCar:start()
  print("self.check: ", pcall(self.check, self))
end

function AbstractCar:drive(pilot)
  print("Car is driving: " .. pilot)
end

--------------------------------------------------------------------------------
-- Car Object: #1

local car_1 = AbstractCar:new {
  chassis = chassis_1:new {},
  engine = engine_1:new {},
  transmission = transmission_1:new {},
  wheel = wheel_1:new {}
}

function car_1:check()
  assert(self.chassis and self.engine and self.transmission and self.wheel)
  assert(self.chassis:hold() == "Chassis_1 ok")
  assert(self.engine:start() == "Engine_1 is roaring")
  assert(self.transmission:shift() == "Transmission_1 is shifting")
  assert(self.wheel:spin() == "Wheel_1 is spinning")
  return "All components are functional"
end

--------------------------------------------------------------------------------
-- Car Object: #2

local car_2 = AbstractCar:new {
  chassis = chassis_2:new {},
  engine = engine_2:new {},
  transmission = transmission_2:new {},
  wheel = wheel_2:new {}
}

function car_2:check()
  assert(self.chassis and self.engine and self.transmission and self.wheel)
  assert(self.chassis:hold() == "Chassis_2 ok")
  assert(self.engine:start() == "Engine_2 is roaring")
  assert(self.transmission:shift() == "Transmission_2 is shifting")
  assert(self.wheel:spin() == "Wheel_2 is spinning")
  return "All components are functional"
end

--------------------------------------------------------------------------------
-- #7. Users:

car_1:start()      --> self.check: 	true	All components are functional
car_1:drive("ana") --> Car is driving: ana

car_2:start()      --> self.check: 	true	All components are functional
car_2:drive("bob") --> Car is driving: bob
