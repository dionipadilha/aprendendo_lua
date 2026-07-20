# Banco de dados

Acesso ao SQLite pela CLI `sqlite3`, sem biblioteca externa:
`os.execute` roda um comando e devolve apenas o STATUS; `io.popen` roda
capturando a saída, que assim pode ser verificada pelo próprio Lua. O
exemplo detecta o binário de forma portátil (`command -v` no POSIX,
`where` no Windows) e encerra graciosamente se o SQLite não estiver
instalado.

| Arquivo | Tema |
|---------|------|
| `sqlite3.lua` | `os.execute` e `io.popen` com a CLI do SQLite; detecção portátil do binário |
| `roteiro.sql` | Roteiro idempotente que (re)cria e povoa as tabelas de exemplo |

Execute a partir deste diretório (`lua5.4 sqlite3.lua`): o
`.read roteiro.sql` procura o script no diretório corrente. O arquivo
`banco_de_dados.db` é gerado na execução e está no `.gitignore`.
