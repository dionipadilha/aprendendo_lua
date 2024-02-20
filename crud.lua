-- Define the database class
local Database = {}
Database.__index = Database

-- Constructor for database
function Database:new()
    local instance = setmetatable({}, Database)
    instance.records = {}
    return instance
end

-- Method to create a new record
function Database:create(id, data)
    if self.records[id] ~= nil then
        return false, "Record with given ID already exists."
    end
    self.records[id] = data
    return true, "Record created successfully."
end

-- Method to read a record by ID
function Database:read(id)
    if self.records[id] == nil then
        return false, "Record not found."
    end
    return true, self.records[id]
end

-- Method to update an existing record
function Database:update(id, newData)
    if self.records[id] == nil then
        return false, "Record to update not found."
    end
    self.records[id] = newData
    return true, "Record updated successfully."
end

-- Method to delete a record
function Database:delete(id)
    if self.records[id] == nil then
        return false, "Record to delete not found."
    end
    self.records[id] = nil
    return true, "Record deleted successfully."
end

-- Example usage
local db = Database:new()
local success, message = db:create(1, {name = "John Doe", age = 30})
print(success and message or "Error") --> Record created successfully.

success, message = db:read(1)
print(success and message.name or message) --> John Doe

success, message = db:update(1, {name = "Jane Doe", age = 31})
print(success and message or "Error") --> Record updated successfully.

success, message = db:delete(1)
print(success and message or "Error") --> Record deleted successfully.
