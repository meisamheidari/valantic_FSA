#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="build.log"
RELEASE_DIR="release"
DELIVERY_DIR="delivery"

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $*" | tee -a "$LOG_FILE"
}

fail() {
  log "ERROR: $*"
  exit 1
}

on_error() {
  log "Build failed (line $1). See above for details."
}
trap 'on_error $LINENO' ERR

log "Build started"

# --- Validate VERSION ---
[[ -f VERSION ]] || fail "VERSION file not found in repo root"
VERSION="$(tr -d '[:space:]' < VERSION)"
[[ -n "$VERSION" ]] || fail "VERSION file is empty"

TIMESTAMP="$(date +"%Y%m%d_%H%M")"
ARCHIVE_NAME="app-${VERSION}-${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${RELEASE_DIR}/${ARCHIVE_NAME}"

# --- Prepare directories ---
mkdir -p "$RELEASE_DIR" "$DELIVERY_DIR"

# --- Cleanup old artifacts ---
log "Cleaning old artifacts in ${RELEASE_DIR}/"
rm -f "${RELEASE_DIR}/"*.tar.gz || true

# --- Collect files to package (only .sh, .py, .js), excluding unwanted dirs ---
log "Collecting source files to package"
TMP_LIST="$(mktemp)"
find . -type f \( -name "*.sh" -o -name "*.py" -o -name "*.js" \) \
  -not -path "./.git/*" \
  -not -path "./node_modules/*" \
  -not -path "./target/*" \
  -not -path "./release/*" \
  -not -path "./delivery/*" \
  -print0 > "$TMP_LIST"

# If no files found, fail clearly
if [[ ! -s "$TMP_LIST" ]]; then
  rm -f "$TMP_LIST"
  fail "No .sh/.py/.js files found to package"
fi

# --- Create archive ---
log "Creating archive: ${ARCHIVE_PATH}"
tar --null --files-from="$TMP_LIST" -czf "$ARCHIVE_PATH"
rm -f "$TMP_LIST"

# --- Delivery step ---
log "Delivering artifact to ${DELIVERY_DIR}/"
cp -f "$ARCHIVE_PATH" "$DELIVERY_DIR/"

log "Success: ${ARCHIVE_NAME}"
log "Build completed"
