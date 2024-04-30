local db_path = "database.db"

local sqlite_queries = {
  [[".read create_music_library.sql"]],
  [[".read insert_musics.sql"]]
}

for _, query in ipairs(sqlite_queries) do
  local cmd = "sqlite3" .. " " .. db_path .. " " .. query
  os.execute(cmd)
end
