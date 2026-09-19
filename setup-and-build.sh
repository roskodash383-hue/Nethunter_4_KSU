#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

printf '%s\n' '== Combined NetHunter + rooted-device workflow =='
printf '%s\n' 'This setup assumes the phone is already rooted.'
printf '%s\n' 'Monitor mode depends on the actual Wi‑Fi chip, driver, firmware, and kernel support.'

if [ "$(id -u 2>/dev/null || echo 0)" -eq 0 ]; then
  printf '%s\n' 'Root shell: detected'
else
  printf '%s\n' 'Root shell: not detected; the device itself still needs to be rooted.'
fi

if [ -d /data/adb/ksu ] || [ -d /data/adb/magisk ]; then
  printf '%s\n' 'Root manager data directory: detected'
else
  printf '%s\n' 'Root manager data directory: not detected'
fi

if [ "$#" -lt 1 ]; then
  printf 'Path to the official ARM64 NetHunter ZIP: '
  read -r SOURCE
else
  SOURCE=$1
fi

if [ ! -f "$SOURCE" ]; then
  printf '%s\n' "Source ZIP not found: $SOURCE" >&2
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  printf '%s\n' 'unzip is required.' >&2
  exit 1
fi

required='data/app/NetHunter.apk data/app/NetHunterTerminal.apk data/app/NetHunterKeX.apk data/app/NetHunterStore.apk data/app/NetHunterStorePrivilegedExtension.apk kalifs-minimal-arm64.tar.xz'

printf '%s\n' 'Checking the official NetHunter ARM64 payloads...'
for entry in $required; do
  if ! unzip -lqq "$SOURCE" "$entry" 2>/dev/null | awk -v wanted="$entry" '$4 == wanted { found=1 } END { exit !found }'; then
    printf '%s\n' "Required entry missing from source ZIP: $entry" >&2
    exit 1
  fi
done

printf '%s\n' 'Extracting required files...'
(CDPATH= cd -- "$ROOT_DIR" && unzip -oq "$SOURCE" \
  'data/app/NetHunter.apk' \
  'data/app/NetHunterTerminal.apk' \
  'data/app/NetHunterKeX.apk' \
  'data/app/NetHunterStore.apk' \
  'data/app/NetHunterStorePrivilegedExtension.apk' \
  'kalifs-minimal-arm64.tar.xz')

printf '%s\n' 'Executing the module build...'
exec "$ROOT_DIR/build-module.sh"
