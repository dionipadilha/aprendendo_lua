-- factory.lua

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

-- Chassis Object:
local chassis_1 = AbstractChassis:new {}
function chassis_1:hold()
  return "Chassis_1 ok"
end

local chassis_2 = AbstractChassis:new {}
function chassis_2:hold()
  return "Chassis_2 ok"
end

--------------------------------------------------------------------------------
-- #3. Engines:

-- Engine Factory:
local AbstractEngine = Factory:new {}
function AbstractEngine:start()
  error("This method should be overridden")
end

-- Engine Object:
local engine_1 = AbstractEngine:new {}
function engine_1:start()
  return "Engine_1 is roaring"
end

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

-- Transmission Object:
local transmission_1 = AbstractTransmission:new {}
function transmission_1:shift()
  return "Transmission_1 is shifting"
end

local transmission_2 = AbstractTransmission:new {}
function transmission_2:shift()
  return "Transmission_2 is shifting"
end

--------------------------------------------------------------------------------
-- #5. Wheels:

-- Wheel Factory:
local AbstractWheel = Factory:new {}
function AbstractWheel:spin()
  error("This method should be overridden")
end

-- Wheel Object:
local wheel_1 = AbstractWheel:new {}
function wheel_1:spin()
  return "Wheel_1 is spinning"
end

local wheel_2 = AbstractWheel:new {}
function wheel_2:spin()
  return "Wheel_2 is spinning"
end

--------------------------------------------------------------------------------
-- #6. Car Assembly:

-- Car Factory:
local AbstractCar = Factory:new {}

function AbstractCar:drive()
  assert(self.chassis and self.engine and self.transmission and self.wheel)
  self.chassis:hold()
  self.engine:start()
  self.transmission:shift()
  self.wheel:spin()
  print("Car is driving: " .. self.id)
end

-- Car Object:
local car_1 = AbstractCar:new {
  id = "ana",
  chassis = chassis_1:new {},
  engine = engine_2:new {},
  transmission = transmission_1:new {},
  wheel = wheel_2:new {}
}

local car_2 = AbstractCar:new {
  id = "bob",
  chassis = chassis_2:new {},
  engine = engine_1:new {},
  transmission = transmission_2:new {},
  wheel = wheel_1:new {}
}

--------------------------------------------------------------------------------
-- #7. User:

print(car_2.engine.start()) --> Engine_2 is roaring
car_1:drive()               --> Car is driving:ana

print(car_2.engine.start()) --> Engine_1 is roaring
car_2:drive()               --> Car is driving: bob
