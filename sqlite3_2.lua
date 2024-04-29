-- inputs:
local db_path = "database.db"

local sqlite_queries = {
  "DROP TABLE artists",
  "CREATE TABLE artists(id INTEGER, name TEXT);",
  "DROP TABLE tracks",
  "CREATE TABLE tracks(id INTEGER, name TEXT, artist TEXT);",
}

-- app functions:
local function sqlite3_cmd(db_path, query)
  local double_quoted_query = '"' .. query .. '"'
  return "sqlite3" .. " " .. db_path .. " " .. double_quoted_query
end

-- process:
for _, query in ipairs(sqlite_queries) do
  local command = sqlite3_cmd(db_path, query)
  os.execute(command)
end
