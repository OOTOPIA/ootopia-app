!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
export "EXTRA_FRONT_END_OPTIONS=--no-sound-null-safety"

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

flutter pub get
flutter build ios --no-sound-null-safety --release --no-codesign
