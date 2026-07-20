-- sqlite3.lua

-- Demonstração de acesso ao SQLite pela CLI (os.execute).

-- Este arquivo pressupõe execução a partir de banco_de_dados/ (o
-- ".read roteiro.sql" abaixo procura o script no diretório corrente).

-- Verifica antes se a CLI sqlite3 está instalada. Quando ausente, apenas
-- avisa e encerra com sucesso (exit 0), para não quebrar a CI em ambientes
-- sem sqlite3. A detecção muda por plataforma: "command -v" é POSIX;
-- no Windows o equivalente é "where" (package.config revela o sistema
-- pelo separador de caminhos — mesmo idioma de ../sistema/dormir.lua).
local ehWindows = package.config:sub(1, 1) == "\\"
local deteccao = ehWindows
  and "where sqlite3 >NUL 2>NUL"
  or "command -v sqlite3 >/dev/null"
local temSqlite = os.execute(deteccao)
if not temSqlite then
  print("Aviso: a CLI 'sqlite3' não está instalada; demonstração pulada.")
  print("Instale-a (ex.: apt install sqlite3) para executar este exemplo.")
  return
end

local sqlite = {}

sqlite.cli = 'sqlite3 %s \"%s\"'
sqlite.bancoDeDados = "banco_de_dados.db"
sqlite.sql = {
  ".read roteiro.sql",
  "SELECT * FROM Tracks;"
}

for _, consulta in ipairs(sqlite.sql) do
  sqlite.comandoCli = sqlite.cli:format(sqlite.bancoDeDados, consulta)
  -- os.execute retorna: sucesso (boolean), tipo de término ("exit" ou
  -- "signal") e o código de saída (ou número do sinal):
  local sucesso, tipoDeTermino, codigo = os.execute(sqlite.comandoCli)
  if not sucesso then
    print(("Erro do Sqlite (%s, código %d): %s"):format(tipoDeTermino, codigo, consulta))
  end
end
