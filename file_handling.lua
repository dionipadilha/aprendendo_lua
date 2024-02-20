-- file_handling_basic.lua

-- Approach #1: Basic File Handling

-- Writing to a file
local writeFile = io.open("test.txt", "w")
if writeFile then
    writeFile:write("Hello, Lua!")
    writeFile:close()
else
    print("Error opening file for writing.")
end

-- Reading from a file
local readFile = io.open("test.txt", "r")
local content = nil
if readFile then
    content = readFile:read("*a")
    readFile:close()
else
    print("Error opening file for reading.")
end

if content then
    print("File content: " .. content)
else
    print("No content read from file.")
end
