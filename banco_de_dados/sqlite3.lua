-- sqlite3.lua

-- Demonstração de acesso ao SQLite pela CLI: os.execute roda um comando
-- e devolve apenas o STATUS; io.popen roda um comando CAPTURANDO a saída,
-- que assim pode ser verificada pelo próprio Lua.

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

--------------------------------------------------------------------------------
-- os.execute: executa o roteiro que (re)cria e preenche as tabelas.

sqlite.comandoRoteiro = sqlite.cli:format(sqlite.bancoDeDados, ".read roteiro.sql")
-- os.execute retorna: sucesso (boolean), tipo de término ("exit" ou
-- "signal") e o código de saída (ou número do sinal):
local sucesso, tipoDeTermino, codigo = os.execute(sqlite.comandoRoteiro)
if not sucesso then
  print(("Erro do Sqlite (%s, código %d): .read roteiro.sql"):format(tipoDeTermino, codigo))
  -- Falha DE VERDADE (exit 1), para o teste de fumaça enxergar um roteiro
  -- quebrado — o exit 0 fica reservado à ausência da CLI, tratada acima.
  os.exit(1)
end

--------------------------------------------------------------------------------
-- io.popen: consulta as faixas capturando a saída do comando — com
-- os.execute o resultado do SELECT iria direto ao stdout e o Lua nunca
-- veria os dados; com io.popen dá para iterar as linhas e verificá-las.

sqlite.comandoConsulta = sqlite.cli:format(sqlite.bancoDeDados, "SELECT * FROM Tracks;")
local processo = assert(io.popen(sqlite.comandoConsulta))
local faixas = 0
for linha in processo:lines() do
  print(linha) --> 1|Antog|1 ... 6|Factorial|3 (uma faixa por linha)
  faixas = faixas + 1
end
-- close em um handle de io.popen devolve o mesmo trio de os.execute:
assert(processo:close(), "a consulta SELECT falhou")

-- propriedade: o roteiro insere exatamente 6 faixas na tabela Tracks.
assert(faixas == 6, "esperava 6 faixas, obtive " .. faixas)
