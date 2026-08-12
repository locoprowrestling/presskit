#!/bin/bash
set -euo pipefail

# $1: source directory to publish from (default: current directory)
# $2: output directory to prepare for GitHub Pages (default: _site)
SRC_DIR="${1:-.}"
OUT_DIR="${2:-_site}"

require_bin() {
  local bin_name="$1"
  if ! command -v "$bin_name" >/dev/null 2>&1; then
    echo "Missing required binary: $bin_name" >&2
    exit 1
  fi
}

require_dir() {
  local dir_path="$1"
  if [[ ! -d "$dir_path" ]]; then
    echo "Missing required directory: $dir_path" >&2
    exit 1
  fi
}

require_bin rsync
require_dir "$SRC_DIR"

mkdir -p "$OUT_DIR"

rsync -a --delete \
  --exclude '.git/' \
  --exclude '.github/' \
  --exclude '_site/' \
  --exclude 'archive/' \
  --exclude 'scripts/' \
  --exclude '_roster-review/' \
  --exclude 'source-assets/' \
  --exclude 'prompts/' \
  --exclude '.gitignore' \
  --exclude 'README.md' \
  --exclude '.DS_Store' \
  "$SRC_DIR"/ "$OUT_DIR"/
