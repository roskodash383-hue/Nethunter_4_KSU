#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE=${1:-}

printf '%s\n' '== NetHunter KernelSU build prep =='
printf '%s\n' 'This workflow assumes the phone is already rooted.'
if [ "$(id -u 2>/dev/null || echo 0)" -eq 0 ]; then
  printf '%s\n' 'Root environment: detected'
else
  printf '%s\n' 'Warning: current shell is not root. The phone itself still needs to be rooted.'
fi

if [ -d /data/adb/ksu ] || [ -d /data/adb/magisk ]; then
  printf '%s\n' 'Root manager data directory: detected'
else
  printf '%s\n' 'Warning: no obvious root manager directory found. KernelSU/Magisk still has to be installed on the device.'
fi

if [ -z "$SOURCE" ]; then
  printf 'Path to the official ARM64 NetHunter ZIP: '
  read -r SOURCE
fi

if [ ! -f "$SOURCE" ]; then
  printf '%s\n' "Source ZIP not found: $SOURCE" >&2
  exit 1
fi

command -v unzip >/dev/null 2>&1 || {
  printf '%s\n' 'unzip is required.' >&2
  exit 1
}

required='data/app/NetHunter.apk data/app/NetHunterTerminal.apk data/app/NetHunterKeX.apk data/app/NetHunterStore.apk data/app/NetHunterStorePrivilegedExtension.apk kalifs-minimal-arm64.tar.xz'

printf '%s\n' 'Checking NetHunter ARM64 payloads...'
for entry in $required; do
  if ! unzip -lqq "$SOURCE" "$entry" 2>/dev/null | awk -v wanted="$entry" '$4 == wanted { found=1 } END { exit !found }'; then
    printf '%s\n' "Required entry missing from source ZIP: $entry" >&2
    exit 1
  fi
done

printf '%s\n' 'Extracting ARM64 NetHunter payloads...'
(CDPATH= cd -- "$ROOT_DIR" && unzip -oq "$SOURCE" \
  'data/app/NetHunter.apk' \
  'data/app/NetHunterTerminal.apk' \
  'data/app/NetHunterKeX.apk' \
  'data/app/NetHunterStore.apk' \
  'data/app/NetHunterStorePrivilegedExtension.apk' \
  'kalifs-minimal-arm64.tar.xz')

printf '%s\n' 'Wireless note: monitor mode depends on chip, driver, firmware, and kernel support.'
printf '%s\n' 'Running validated module build...'
exec "$ROOT_DIR/build-module.sh"