-- output_formatting.lua

-- Basic techniques for output formatting

-- Basic String Printing:
print("Lua", "is", "fun") --> Lua	is	fun (separated by tabs)

-- String Concatenation:
print("Lua" .. "-" .. "is" .. "-" .. "fun") --> Lua-is-fun

-- String Formatting:
print(string.format("%s-%s-%s", "Lua", "is", "fun")) --> Lua-is-fun

-- Formatting Numbers:
print(string.format("pi is %.2f", 3.1415)) --> pi is 3.14

-- Multiline Strings:
local multiline = [[first line
second line
]]
print(multiline)
--> first line
--> second line

-- Concatenating List Elements:
local list = { "Ana", "Bob", "Charlie" }
print("Names: ", table.concat(list, "-")) --> Names: 	Ana-Bob-Charlie

-- Unpacking List Elements:
local list = { "Ana", "Bob", "Charlie" }
print("Names: ", table.unpack(list)) --> Names: 	Ana	Bob	Charlie

-- Using Metatables for Custom __tostring:
local p = setmetatable(
  { age = 42, height = 102 },
  { __tostring = function(p) return "person of age " .. p.age end }
)
print(p) --> person of age 42

-- Date and Time Formatting:
local today = os.date("%Y-%m-%d")
print("Today's date:", today) --> Today's date:	2024-06-19

-- Pattern Matching:
local text = "Hello Lua user!"
local pattern = "(%a+)%s+(%a+)%s+(%a+)!"
local word1, word2, word3 = string.match(text, pattern)
print(word1, word2, word3) --> Hello	Lua	user

-- Centering Text:
local function center(str, width)
  local len = #str
  if len >= width then return str end
  local padding = (width - len) / 2
  local left_padding = math.floor(padding)
  local right_padding = math.ceil(padding)
  return string.rep(" ", left_padding) .. str .. string.rep(" ", right_padding)
end

print("|" .. center("centro", 10) .. "|") --> |  centro  |
print("|" .. center("centro", 11) .. "|") --> |  centro   |
print("|" .. center("centro", 12) .. "|") --> |   centro   |
