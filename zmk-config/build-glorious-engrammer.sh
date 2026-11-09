#!/bin/sh
set -eu

# Select the installed SDK explicitly for pristine builds.
export ZEPHYR_TOOLCHAIN_VARIANT="${ZEPHYR_TOOLCHAIN_VARIANT:-zephyr}"

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
config="$root/zmk-config/config"

cd "$root/app"
"$root/.venv/bin/west" build -p always -d ../build/glove80-left -b glove80_lh -- \
    -DZMK_CONFIG="$config"
"$root/.venv/bin/west" build -p always -d ../build/glove80-right -b glove80_rh -- \
    -DZMK_CONFIG="$config"

cp "$root/build/glove80-left/zephyr/zmk.uf2" \
    "$root/build/glorious-engrammer-v41-glove80-left.uf2"
cp "$root/build/glove80-right/zephyr/zmk.uf2" \
    "$root/build/glorious-engrammer-v41-glove80-right.uf2"
