#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Keep the public entry point stable while maintaining one build implementation.
exec "$ROOT_DIR/prepare-and-build.sh" "$@"
