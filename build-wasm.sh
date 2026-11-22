#!/usr/bin/env bash
set -euo pipefail

# Build JA++ WebAssembly SIDE_MODULE=2 binaries (cgamewasm32.wasm, jampgamewasm32.wasm, uiwasm32.wasm)
# and package japp-wasm.zip ready to drop into OpenJK Web (openjk-wasm).
#
# Usage:
#   source /path/to/emsdk/emsdk_env.sh
#   bash build-wasm.sh [build_dir] [out_dir]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${1:-${SCRIPT_DIR}/build-wasm}"
OUT_DIR="${2:-${SCRIPT_DIR}/dist-wasm}"
STAGE_DIR="${OUT_DIR}/japp"

if ! command -v emcmake >/dev/null 2>&1; then
	echo "ERROR: emcmake not found in PATH. Source emsdk_env.sh first." >&2
	exit 1
fi

mkdir -p "${BUILD_DIR}" "${STAGE_DIR}"

GENERATOR_ARGS=()
if command -v ninja >/dev/null 2>&1; then
	GENERATOR_ARGS=(-G Ninja)
fi

emcmake cmake "${GENERATOR_ARGS[@]}" -S "${SCRIPT_DIR}" -B "${BUILD_DIR}" \
	-DCMAKE_BUILD_TYPE=Release

cmake --build "${BUILD_DIR}" -j"$(nproc 2>/dev/null || echo 4)"

cp -v "${BUILD_DIR}/cgamewasm32.wasm" \
	"${BUILD_DIR}/jampgamewasm32.wasm" \
	"${BUILD_DIR}/uiwasm32.wasm" \
	"${SCRIPT_DIR}/description.txt" \
	"${STAGE_DIR}/"

if [ -d "${SCRIPT_DIR}/wasm-assets" ]; then
	cp -rv "${SCRIPT_DIR}/wasm-assets/." "${STAGE_DIR}/"
fi

if command -v python3 >/dev/null 2>&1; then
	python3 - "${STAGE_DIR}" "${OUT_DIR}/japp-wasm.zip" <<'PY'
import os, sys, zipfile
stage_dir, zip_path = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
    for root, dirs, files in os.walk(stage_dir):
        dirs.sort()
        for fn in sorted(files):
            full = os.path.join(root, fn)
            rel = os.path.relpath(full, stage_dir).replace("\\", "/")
            zf.write(full, arcname=f"japp/{rel}")
print(f"Packaged {zip_path} ({os.path.getsize(zip_path) / 1024:.1f} KB)")
PY
fi

echo "Done! Staged in ${STAGE_DIR}"
