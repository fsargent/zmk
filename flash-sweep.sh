#!/usr/bin/env bash
#
# Build Ferris Sweep / Cradio firmware for nice!nano v2 and copy each UF2
# onto the bootloader volume.
#
# Usage:
#   ./flash-sweep.sh                 # build left+right, then flash both
#   ./flash-sweep.sh --build-only    # just build
#   ./flash-sweep.sh --left          # build + flash left half only
#   ./flash-sweep.sh --right         # build + flash right half only
#   ./flash-sweep.sh --reset         # also build settings_reset UF2
#   ./flash-sweep.sh --no-pristine   # reuse existing build dirs
#
# Both halves mount as NICENANO. Flash one half at a time: double-tap reset
# on that nice!nano, wait for the copy, then do the other half.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="${ROOT}/app"
ZMK_CONFIG="${ZMK_CONFIG:-${ROOT}/zmk-config/config}"
export ZEPHYR_TOOLCHAIN_VARIANT="${ZEPHYR_TOOLCHAIN_VARIANT:-zephyr}"
export ZEPHYR_SDK_INSTALL_DIR="${ZEPHYR_SDK_INSTALL_DIR:-${HOME}/zephyr-sdk-0.17.0}"
WEST="${ROOT}/.venv/bin/west"

LEFT_SHIELD="cradio_left"
RIGHT_SHIELD="cradio_right"
BOARD="nice_nano_v2"

LEFT_BUILD="${ROOT}/build/sweep-left"
RIGHT_BUILD="${ROOT}/build/sweep-right"
RESET_BUILD="${ROOT}/build/sweep-reset"

VOL="/Volumes/NICENANO"

DO_LEFT=1
DO_RIGHT=1
DO_RESET=0
BUILD_ONLY=0
PRISTINE="-p"

for arg in "$@"; do
  case "$arg" in
    --left)        DO_RIGHT=0 ;;
    --right)       DO_LEFT=0 ;;
    --reset)       DO_RESET=1 ;;
    --build-only)  BUILD_ONLY=1 ;;
    --no-pristine) PRISTINE="" ;;
    -h|--help)
      sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 2
      ;;
  esac
done

build_shield() {
  local shield="$1" build_dir="$2"
  echo ">>> Building ${BOARD} + ${shield} -> ${build_dir}"
  ( cd "$APP_DIR" && "$WEST" build ${PRISTINE:+$PRISTINE} -d "$build_dir" -b "$BOARD" -- \
      -DSHIELD="${shield}" -DZMK_CONFIG="${ZMK_CONFIG}" )
}

flash_half() {
  local uf2="$1" label="$2"
  if [ ! -f "$uf2" ]; then
    echo "!!! Missing firmware: $uf2" >&2
    exit 1
  fi

  echo ">>> Waiting for ${label} bootloader (${VOL})..."
  echo "    Double-tap reset on the ${label} nice!nano now."
  until [ -d "$VOL" ]; do
    sleep 1
  done

  echo ">>> Copying $(basename "$uf2") -> ${VOL}"
  cp "$uf2" "$VOL/" 2>/dev/null || true
  sync
  echo ">>> ${label} half flashed. Wait for NICENANO to eject before the next half."
  until [ ! -d "$VOL" ]; do
    sleep 1
  done
}

[ "$DO_LEFT" = 1 ]  && build_shield "$LEFT_SHIELD"  "$LEFT_BUILD"
[ "$DO_RIGHT" = 1 ] && build_shield "$RIGHT_SHIELD" "$RIGHT_BUILD"
[ "$DO_RESET" = 1 ] && build_shield "settings_reset" "$RESET_BUILD"

if [ -f "${LEFT_BUILD}/zephyr/zmk.uf2" ]; then
  cp "${LEFT_BUILD}/zephyr/zmk.uf2" "${ROOT}/build/felix-sweep-left.uf2"
fi
if [ -f "${RIGHT_BUILD}/zephyr/zmk.uf2" ]; then
  cp "${RIGHT_BUILD}/zephyr/zmk.uf2" "${ROOT}/build/felix-sweep-right.uf2"
fi
if [ -f "${RESET_BUILD}/zephyr/zmk.uf2" ]; then
  cp "${RESET_BUILD}/zephyr/zmk.uf2" "${ROOT}/build/nice-nano-settings-reset.uf2"
fi

if [ "$BUILD_ONLY" = 1 ]; then
  echo ">>> Build complete (--build-only); skipping flash."
  echo "    Left:  ${ROOT}/build/felix-sweep-left.uf2"
  echo "    Right: ${ROOT}/build/felix-sweep-right.uf2"
  [ "$DO_RESET" = 1 ] && echo "    Reset: ${ROOT}/build/nice-nano-settings-reset.uf2"
  exit 0
fi

[ "$DO_LEFT" = 1 ]  && flash_half "${ROOT}/build/felix-sweep-left.uf2" "LEFT"
[ "$DO_RIGHT" = 1 ] && flash_half "${ROOT}/build/felix-sweep-right.uf2" "RIGHT"

echo ">>> Done."
