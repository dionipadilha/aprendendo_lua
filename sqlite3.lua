local sqlite3 = {}

function sqlite3.run(db, sql)
  local cmd = "sqlite3 ".. db .. sql
  os.execute(cmd)
end

sqlite3.run("database.db ", ".tables")
