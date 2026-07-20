#!/usr/bin/env bash
# Teste de fumaça: executa todos os arquivos .lua do repositório com Lua 5.4.
# Cada arquivo roda a partir do seu próprio diretório (para que os
# requires relativos funcionem) e deve terminar com código de saída 0.
#
# Uso: ./executar_testes.sh
set -u

LUA="${LUA:-lua5.4}"
TIMEOUT_SECS="${TIMEOUT_SECS:-90}"

# Fallback para macOS/BSD: usa timeout se existir, senão gtimeout
# (coreutils via Homebrew), senão roda sem limite de tempo, com aviso.
if command -v timeout >/dev/null 2>&1; then
  TIMEOUT_CMD=(timeout "$TIMEOUT_SECS")
elif command -v gtimeout >/dev/null 2>&1; then
  TIMEOUT_CMD=(gtimeout "$TIMEOUT_SECS")
else
  echo "Aviso: 'timeout'/'gtimeout' não encontrados; executando sem limite de tempo." >&2
  TIMEOUT_CMD=()
fi

# As esperas propositais dos exemplos são curtas (décimos de segundo a ~1s);
# nenhum arquivo do repositório deve chegar perto do timeout acima.
failures=0
total=0

cd "$(dirname "$0")"

while IFS= read -r file; do
  total=$((total + 1))
  dir=$(dirname "$file")
  name=$(basename "$file")
  if ! output=$(cd "$dir" && ${TIMEOUT_CMD[@]+"${TIMEOUT_CMD[@]}"} "$LUA" "$name" </dev/null 2>&1); then
    failures=$((failures + 1))
    echo "FAIL: $file"
    echo "$output" | head -3 | sed 's/^/      /'
  fi
done < <(find . -name '*.lua' -not -path './.git/*' | sort)

echo "----------------------------------------"
echo "Total: $total | Falhas: $failures"
[ "$failures" -eq 0 ]
