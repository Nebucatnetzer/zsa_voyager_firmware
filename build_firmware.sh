#!/usr/bin/env bash
KB="voyager"
KM="source"
mkdir -p qmk_firmware
rsync -r --delete --chmod +w "$QMK_FIRMWARE"/ qmk_firmware/
chmod +w -R qmk_firmware
rm -rf qmk_firmware/keyboards/zsa/voyager/keymaps/source
mkdir -p qmk_firmware/keyboards/zsa/voyager/keymaps
cp -rv source qmk_firmware/keyboards/zsa/voyager/keymaps/source
cd qmk_firmware/
SKIP_GIT=1 qmk compile --clean -kb ${KB} -km ${KM}
