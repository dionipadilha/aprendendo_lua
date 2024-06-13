-- Define the database class
local Database = {
  records = {}
}

-- Constructor for database
function Database:new(object)
  object = object or {}
  self.__index = self
  return setmetatable(object, self)
end

-- Method to create a new record
function Database:create(id, data)
  assert(self.records[id] == nil, "Record with given ID already exists.")
  assert(data ~= nil and data ~= "", "Invalid record data.")
  self.records[id] = data
  return true
end

-- Method to read a record by ID
function Database:read(id)
  assert(self.records[id] ~= nil, "Record not found.")
  return self.records[id]
end

-- Method to update an existing record
function Database:update(id, newData)
  assert(self.records[id] ~= nil, "Record not found.")
  assert(newData ~= nil and newData ~= "", "Invalid record data.")
  self.records[id] = newData
  return self.records[id]
end

-- Method to delete a record
function Database:delete(id)
  assert(self.records[id] ~= nil, "Record not found.")
  self.records[id] = nil
  return true
end

-- Example usage
local function main()
  local db = Database:new {}

  db:create(1, { name = "John Doe", age = 42 })

  local record = db:read(1)
  print(record.name, record.age) --> John Doe 42

  db:update(1, { name = "Jane Doe", age = 31 })
  record = db:read(1)
  print(record.name, record.age) --> Jane Doe 31

  print(db:delete(1))            --> true
  local status, err = pcall(function() return db:read(1) end)
  print(status, err) --> false   Record not found.
end

main()
