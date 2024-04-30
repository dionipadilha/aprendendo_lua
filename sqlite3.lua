local sqlite = {}

function sqlite.query_format(query)
  local formated_query = ' "' .. query .. '"'
  return formated_query
end

function sqlite:cli_execute(query)
  local quoted_query = self.query_format(query)
  local command = self.connector .. quoted_query
  return os.execute(command)
end

sqlite.connector = "sqlite3 music.db"
sqlite.queries = {
  ".read music_library.sql",
  ".read insert_musics.sql"
}

for _, query in ipairs(sqlite.queries) do
  local success, exit_code, signal = sqlite:cli_execute(query)
  if not success then
    print("Sqlite Error: " .. query)
  end
end
