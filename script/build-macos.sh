#!/usr/bin/env bash

set -u

set -e

set -x

# https://flutter.cn/community/china
export PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub
export FLUTTER_STORAGE_BASE_URL=https://mirrors.tuna.tsinghua.edu.cn/flutter

USER=`whoami`

/Users/${USER}/fvm/versions/3.0.4/bin/flutter build macos --release --no-tree-shake-icons

# package to dmg file
rm -f macos/installer/tik.dmg
appdmg macos/installer/dmg_creator/config.json macos/installer/tik.dmg