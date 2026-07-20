-- file_handling_basic.lua

-- Approach #1:

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

-- Approach #2:

-- create a file if not exists:
local file = assert(io.open("demofile.txt", "w"))
file:write("toast!")
assert(file:close())

-- open a file for reading:
file = assert(io.open("demofile.txt"))
print(file:read()) --> toast!
assert(file:close())
