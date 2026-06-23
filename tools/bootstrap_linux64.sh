#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/build/bootstrap-linux64"
PREFIX="$OUT/prefix"
LOG="$OUT/build.log"
mkdir -p "$OUT"

exec > >(tee "$LOG") 2>&1

echo "== Eneboo Linux x86-64 bootstrap =="
echo "date: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
echo "commit: $(git -C "$ROOT" rev-parse HEAD)"
echo "host: $(uname -a)"
echo "gcc: $(g++ --version | head -n 1)"
echo

missing=0
for cmd in gcc g++ make perl sed awk grep patch pkg-config; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "MISSING COMMAND: $cmd"
    missing=1
  fi
done

for header in \
  /usr/include/X11/Xlib.h \
  /usr/include/X11/extensions/Xinerama.h \
  /usr/include/postgresql/libpq-fe.h; do
  if [[ ! -e "$header" ]]; then
    echo "MISSING HEADER: $header"
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  cat <<'EOF'

Install the bootstrap dependencies in Ubuntu/Debian with:

sudo apt-get update
sudo apt-get install -y \
  build-essential perl pkg-config patch \
  libx11-dev libxext-dev libxinerama-dev libxrender-dev libxrandr-dev \
  libxft-dev libfontconfig1-dev libfreetype6-dev \
  libjpeg-dev libpng-dev zlib1g-dev \
  libpq-dev libssl-dev libnsl-dev
EOF
  exit 2
fi

cd "$ROOT"

for patch_file in "$ROOT"/patches/legacy/*.patch; do
  [[ -e "$patch_file" ]] || continue
  if patch --dry-run -p1 < "$patch_file" >/dev/null 2>&1; then
    echo "Applying $(basename "$patch_file")"
    patch -p1 < "$patch_file"
  else
    echo "Skipping $(basename "$patch_file") (already applied or not applicable)"
  fi
done

rm -rf "$PREFIX"
mkdir -p "$PREFIX"

export BUILD_NUMBER="bootstrap-$(git rev-parse --short HEAD)"
export MAKEFLAGS=""

set +e
bash ./build.sh \
  -prefix "$PREFIX" \
  -platform linux-g++-64 \
  -quick \
  -verbose \
  -single
status=$?
set -e

echo
echo "build exit status: $status"

if [[ $status -ne 0 ]]; then
  echo "== Last 200 log lines =="
  tail -n 200 "$LOG" || true
  echo
  echo "Bootstrap failed as expected; inspect: $LOG"
  exit "$status"
fi

echo "== Produced binaries =="
find "$PREFIX" -maxdepth 3 -type f -perm -111 -print | sort

echo "Bootstrap succeeded: $PREFIX"
