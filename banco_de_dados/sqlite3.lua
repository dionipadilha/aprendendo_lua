local sqlite = {}

sqlite.cli = 'sqlite3 %s \"%s\"'
sqlite.banco_de_dados = "banco_de_dados.db"
sqlite.sql = {
  ".read roteiro.sql",
  "SELECT * FROM Tracks;"
}

for _, consulta in ipairs(sqlite.sql) do
  sqlite.comando_cli = sqlite.cli:format(sqlite.banco_de_dados, consulta)
  local sucesso, codigo_de_saida, sinal = os.execute(sqlite.comando_cli)
  if not sucesso then print("Erro do Sqlite: " .. consulta) end
end
