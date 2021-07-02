!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

# echo "API_URL=${API_URL} 
# AMPLITUDE_KEY=${AMPLITUDE_KEY}" > .env

cat > .env <<EOL
API_URL=${API_URL}
AMPLITUDE_KEY=${AMPLITUDE_KEY}
EOL
cat .env

flutter clean
flutter pub cache repair
flutter pub get
pod install --repo-update
flutter build ios --release --no-codesign --no-sound-null-safety
