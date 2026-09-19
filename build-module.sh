#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
OUTPUT=${1:-"$ROOT_DIR/nethunter-ksu-xt2513v.zip"}

required_files='module.prop META-INF/com/google/android/update-binary META-INF/com/google/android/update-magisk META-INF/com/google/android/update-recovery post-fs-data.sh'
required_payloads='data/app/NetHunter.apk data/app/NetHunterTerminal.apk data/app/NetHunterKeX.apk data/app/NetHunterStore.apk data/app/NetHunterStorePrivilegedExtension.apk kalifs-minimal-arm64.tar.xz'

for path in $required_files $required_payloads; do
  if [ ! -f "$ROOT_DIR/$path" ] || [ ! -s "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Missing required file: $path" >&2
    exit 1
  fi
done

for script in \
  customize.sh \
  post-fs-data.sh \
  META-INF/com/google/android/update-binary \
  META-INF/com/google/android/update-magisk \
  META-INF/com/google/android/update-recovery \
  tools/*.sh; do
  sh -n "$ROOT_DIR/$script"
done

if ! command -v zip >/dev/null 2>&1; then
  printf '%s\n' 'The zip command is required to build the module.' >&2
  exit 1
fi

case "$OUTPUT" in
  /*) : ;;
  *) OUTPUT="$ROOT_DIR/$OUTPUT" ;;
esac

case "$OUTPUT" in
  "$ROOT_DIR"/*) : ;;
  *) printf '%s\n' 'Output ZIP must be inside the repository.' >&2; exit 1 ;;
esac

rm -f "$OUTPUT"
(CDPATH= cd -- "$ROOT_DIR" && zip -qr9 "$OUTPUT" . \
  -x './.git/*' './.DS_Store' '*/.DS_Store' "./${OUTPUT#"$ROOT_DIR/"}")

printf 'Built %s (%s)\n' "$OUTPUT" "$(du -h "$OUTPUT" | awk '{print $1}')"