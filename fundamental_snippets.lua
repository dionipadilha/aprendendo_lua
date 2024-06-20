-- Hello World:
print("Hello World!")

-- Basic Arithmetic Operations
local sum = 1 + 1
local difference = 10 - 4
local product = 7 * 6
local quotient = 20 / 5
local remainder = 10 % 3

-- Functions:
local function plusOne(x) return x + 1 end
local function add(a, b) return a + b end
local double = function(x) return 2 * x end

-- Data Types:
local person = {                  -- table (dict)
  friends = { "Ana", "Charlie" }, -- table (list)
  name = "Bob",                   -- string
  age = 42,                       -- number (int)
  heigh = 1.82,                   -- number (float)
  isAdult = true,                 -- boolean
  eat = function(food) end        -- function
}

-- Dot Notation:
function person:sayHi() return ("Hi, my name is " .. self.name) end -- function

-- Conditional:
if person.age > 18 then person.isAdult = true end

-- Loops:
for i = 1, #person.friends do print(person.friends[i]) end

for _, friend in ipairs(person.friends) do print(friend) end

for key, value in pairs(person) do print(key, value) end

person.age = 1
while person.age < 18 do
  person.isAdult = false
  person.age = person.age + 1
end
person.isAdult = true

person.age = 1
repeat
  person.isAdult = false
  person.age = person.age + 1
until person.age > 18
person.isAdult = true

-- Lists
local friends = table.pack("Charlie", "Ana")
table.insert(friends, "Bob")
table.insert(friends, 2, "Alex")
table.sort(friends)
table.remove(friends)
table.remove(friends, 1)
print(table.concat(friends, ", "))
local a, b, c = table.unpack(friends)
print(b)

-- Exception Handling
local function entry(person)
  assert(person.isAdult, "Access denied")
end
local success, err = pcall(entry, person)
if not success then
  print(success, err)
else
  print(success, "Access allowed")
end

-- File Handling
local file = assert(io.open("demofile.txt", "w"))
file:write("toast!")
assert(file:close())

file = assert(io.open("demofile.txt"))
print(file:read())
assert(file:close())
