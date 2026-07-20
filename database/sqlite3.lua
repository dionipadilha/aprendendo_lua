local sqlite = {}

sqlite.cli = 'sqlite3 %s \"%s\"'
sqlite.database = "database.db"
sqlite.sql = {
  ".read script.sql",
  "SELECT * FROM Tracks;"
}

for _, query in ipairs(sqlite.sql) do
  sqlite.cli_cmd = sqlite.cli:format(sqlite.database, query)
  local success, exit_code, signal = os.execute(sqlite.cli_cmd)
  if not success then print("Sqlite Error: " .. query) end
end
