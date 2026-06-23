#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:-$ROOT/build/audit}"
mkdir -p "$OUT"

{
  echo "# Eneboo source audit"
  echo
  echo "Generated: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  echo "Commit: $(git -C "$ROOT" rev-parse HEAD 2>/dev/null || true)"
  echo "Host: $(uname -a)"
  echo
  echo "## Toolchain"
  for tool in gcc g++ clang clang++ make cmake qmake qmake-qt3 qmake-qt5 qmake6 python3 perl; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf '%-12s %s\n' "$tool" "$(command -v "$tool")"
      "$tool" --version 2>/dev/null | head -n 1 || true
    fi
  done
} > "$OUT/summary.txt"

find "$ROOT" -path "$ROOT/.git" -prune -o -type f -print \
  | sed "s#^$ROOT/##" | LC_ALL=C sort > "$OUT/files.txt"

find "$ROOT" -path "$ROOT/.git" -prune -o -type f \
  \( -name '*.pro' -o -name '*.pri' -o -name 'Makefile*' -o -name 'configure*' \
     -o -name '*.m4' -o -name '*.sh' -o -name '*.py' -o -name 'CMakeLists.txt' \) \
  -print | sed "s#^$ROOT/##" | LC_ALL=C sort > "$OUT/build-files.txt"

find "$ROOT" -path "$ROOT/.git" -prune -o -type f \
  \( -iname '*qsa*' -o -iname '*script*' -o -iname '*qt*' -o -iname '*sql*' \
     -o -iname '*kugar*' -o -iname '*postgres*' \) \
  -print | sed "s#^$ROOT/##" | LC_ALL=C sort > "$OUT/components.txt"

{
  echo "# Extension counts"
  find "$ROOT" -path "$ROOT/.git" -prune -o -type f -print \
    | awk '
      { n=$0; sub(/^.*\//,"",n); if (n !~ /\./) ext="[none]"; else { sub(/^.*\./,"",n); ext="." tolower(n) } count[ext]++ }
      END { for (e in count) printf "%8d %s\n", count[e], e }
    ' | sort -nr
} > "$OUT/extensions.txt"

{
  echo "# Candidate entry points"
  grep -RIl --exclude-dir=.git --include='*.cpp' --include='*.cc' --include='*.cxx' \
    -E '(^|[^[:alnum:]_])main[[:space:]]*\(' "$ROOT" 2>/dev/null \
    | sed "s#^$ROOT/##" | sort || true
  echo
  echo "# qmake roots"
  grep -RIl --exclude-dir=.git --include='*.pro' -E '(^|[[:space:]])TEMPLATE[[:space:]]*=' "$ROOT" 2>/dev/null \
    | sed "s#^$ROOT/##" | sort || true
} > "$OUT/entry-points.txt"

{
  echo "# Legacy API indicators"
  for token in QSA QSInterpreter FLSqlCursor FLSqlQuery FLApplication aqApp Kugar Qt3Support; do
    printf '\n## %s\n' "$token"
    grep -RIl --exclude-dir=.git "$token" "$ROOT" 2>/dev/null \
      | sed "s#^$ROOT/##" | head -n 200 || true
  done
} > "$OUT/legacy-api.txt"

printf 'Audit written to %s\n' "$OUT"
