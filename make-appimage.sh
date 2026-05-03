#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q vice | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/VICE-Team/svn-mirror/e635822a932aba8387fabb454d4d59218a952187/vice/data/common/CBM_Logo.svg

# Deploy dependencies
quick-sharun /usr/bin/c1541 \
/usr/bin/cartconv \
/usr/bin/petcat \
/usr/bin/vsid \
/usr/bin/x128 \
/usr/bin/x64 \
/usr/bin/x64dtv \
/usr/bin/x64sc \
/usr/bin/xcbm2 \
/usr/bin/xcbm5x0 \
/usr/bin/xpet \
/usr/bin/xplus4 \
/usr/bin/xscpu64 \
/usr/bin/xvic \
/usr/share/vice

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
