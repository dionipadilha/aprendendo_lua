-- file_handling.lua

-- Approach #2: Object-Oriented File Handler

-- Define the FileHandler prototype
local FileHandler = {}
FileHandler.__index = FileHandler

-- Constructor for the FileHandler
function FileHandler.new(fileName)
    local self = setmetatable({}, FileHandler)
    self.fileName = fileName
    return self
end

-- Method to write to a file
function FileHandler:write(content)
    local writeFile = io.open(self.fileName, "w")
    if writeFile then
        writeFile:write(content)
        writeFile:close()
    else
        print("Error opening file for writing.")
    end
end

-- Method to read from a file
function FileHandler:read()
    local readFile = io.open(self.fileName, "r")
    local content = nil
    if readFile then
        content = readFile:read("*a")
        readFile:close()
        return content
    else
        print("Error opening file for reading.")
        return nil
    end
end

-- Usage
local fileHandler = FileHandler.new("test.txt")
fileHandler:write("Hello, Lua!")
local content = fileHandler:read()

if content then
    print("File content: " .. content)
else
    print("No content read from file.")
end
