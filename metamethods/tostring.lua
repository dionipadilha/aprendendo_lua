-- Person Class Definition:

local Person = {
  firstName = "",
  lastName = "",
  age = 0
}

function Person:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function Person:__tostring()
  return table.concat({
    "First Name: " .. self.firstName,
    "Last Name: " .. self.lastName,
    "Age: " .. self.age
  }, ", ")
end

local person1 = Person:new { firstName = "John", lastName = "Doe", age = 30 }
local person2 = Person:new { firstName = "Jane", lastName = "Smith", age = 25 }

print(person1) --> First Name: John, Last Name: Doe, Age: 30
print(person2) --> First Name: Jane, Last Name: Smith, Age: 25
