-- polymorphism.lua

-- different classes to respond differently to the same function call

--------------------------------------------------------------------------------
-- Base animals class:

Animal = {
  className = "animal"
}

function Animal:new(instance)
  instance = instance or {}
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function Animal:walk()
  return true, string.format("This %s can walk", self.className)
end

--------------------------------------------------------------------------------
-- Subclasses of Animal:

Bird = Animal:new {
  className = "bird"
}

function Bird:fly()
  return true, "This bird can fly"
end

--------------------------------------------------------------------------------
-- Subclasses of Bird:

-- Sparrow class:
Sparrow = Bird:new {}

-- Penguin class:
Penguin = Bird:new {}
function Penguin:fly()
  return false, "Penguins can't fly"
end

--------------------------------------------------------------------------------
-- Make a bird walk:

print(Sparrow:walk()) --> true This bird can walk
print(Penguin:walk()) --> true This bird can walk

--------------------------------------------------------------------------------
-- Make a bird fly:

print(Sparrow:fly()) --> true This bird can fly
print(Penguin:fly()) --> false Penguins can't fly

--------------------------------------------------------------------------------
