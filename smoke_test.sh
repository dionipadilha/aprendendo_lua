#!/usr/bin/env bash
# Smoke test: executa todos os arquivos .lua do repositório com Lua 5.4.
# Cada arquivo roda a partir do seu próprio diretório (para que os
# requires relativos funcionem) e deve terminar com código de saída 0.
#
# Uso: ./smoke_test.sh
set -u

LUA="${LUA:-lua5.4}"
TIMEOUT_SECS="${TIMEOUT_SECS:-90}"

# Exemplos que usam busy-wait (delay proposital) demoram até ~30s;
# nenhum arquivo do repositório deve exceder o timeout abaixo.
failures=0
total=0

cd "$(dirname "$0")"

while IFS= read -r file; do
  total=$((total + 1))
  dir=$(dirname "$file")
  name=$(basename "$file")
  if ! output=$(cd "$dir" && timeout "$TIMEOUT_SECS" "$LUA" "$name" </dev/null 2>&1); then
    failures=$((failures + 1))
    echo "FAIL: $file"
    echo "$output" | head -3 | sed 's/^/      /'
  fi
done < <(find . -name '*.lua' -not -path './.git/*' | sort)

echo "----------------------------------------"
echo "Total: $total | Falhas: $failures"
[ "$failures" -eq 0 ]
