local JSON = require "json"

local function main(luaTable)
  local json = JSON:encode(luaTable)
  print(json)
  local decodedTable = JSON:decode(json)
  print(decodedTable.name) --> John Doe
  for _, hobby in ipairs(decodedTable.hobbies) do print(hobby) end
end

local luaTable = {
  name = "Bob",
  age = 42,
  isStudent = false,
  hobbies = { "reading", "gaming", "coding" },
  address = {
    street = "123 Lua Lane",
    city = "Scripttown",
    zipcode = "12345"
  }
}

main(luaTable)
