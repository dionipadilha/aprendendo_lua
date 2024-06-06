-- readonly.lua

--------------------------------------------------------------------------------
-- creates a readonly class:
local ReadOnly = {}

function ReadOnly:new(object)
  object = object or {}
  self.__index = object
  self.__newindex = function() error("\ncannot change a constant value", 2) end
  -- self.__metatable = false -- Protec the metatable
  return setmetatable(object, self)
end

--------------------------------------------------------------------------------
-- Example usage of constants values:

local MathConstants = ReadOnly:new {
  Pi = 3.14159,
  E = 2.71828,
  Degree = 0.01745,
  GoldenRatio = 1.61803,
  GoldenAngle = 137.5
}

print(MathConstants.Pi, type(MathConstants.Pi)) --> 3.14159 number



--------------------------------------------------------------------------------
-- Example usage of enumerations:

local function digitalWrite(pin, value)
  --assert(type(pin) == "number")
  --assert(type(value) == "boolean")
  print(tostring(pin) .. ": " .. tostring(value))
end

local Pin = ReadOnly:new { LED_BUILTIN = 13 }
local Level = ReadOnly:new { LOW = false, HIGH = true }

digitalWrite(Pin.LED_BUILTIN, Level.LOW)  --> 13: false
digitalWrite(Pin.LED_BUILTIN, Level.HIGH) --> 13: true



--------------------------------------------------------------------------------
-- unit tests:

local function runTests()
  print("\n ----------------------- unit tests ----------------------- ")

  local function immutability()
    print "\n#1. test immutability:"
    print("expected: false: cannot change a constant value\n")
    print("MathConstants:", pcall(function() MathConstants.Pi = 3.14 end))
    print("Pin:", pcall(function() Pin.LED_BUILTIN = 12 end))
  end
  immutability()

  local function sameMetatable()
    print "\n#2. test metatable:"
    print("expected: the same metatable for all subclasses\n")
    print("name          ", "table                  ", "metatable")
    print("MathConstants:", MathConstants, getmetatable(MathConstants))
    print("Pin:          ", Pin, getmetatable(Pin))
    print("Level:        ", Level, getmetatable(Level))
  end
  sameMetatable()
end
runTests()
--------------------------------------------------------------------------------
