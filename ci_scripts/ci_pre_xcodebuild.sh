#!/bin/sh

# Carthage copy frameworks
/usr/local/bin/carthage copy-frameworks

# (少なくとも)9.6.0以降において FirebaseAnalytics に含まれるライブラリ PromisesObjC.xcframework は、
# CarthageでインストールするためにFirebase公式が用意したバイナリ中には含まれないため、手動インストールする。
PROMISES_OBJC_ARCHIVE_URL=https://github.com/shin-carpediem/PromisesObjC.xcframework/archive/refs/tags/1.0.0.zip
SCRIPT_DIR=$(cd $(dirname $0);pwd)
PROMISES_OBJC_ARCHIVE_FILE=${SCRIPT_DIR}/PromisesObjC.zip
PROJECT_ROOT_DIR=$(cd ..;pwd)
PROMISES_OBJC_INSTALL_DIR=${PROJECT_ROOT_DIR}/Carthage/Build

echo "🏃 Installing PromisesObjC.xcframework."
curl -L ${PROMISES_OBJC_ARCHIVE_URL} --output ${PROMISES_OBJC_ARCHIVE_FILE}
unzip -q -o ${PROMISES_OBJC_ARCHIVE_FILE} -d ${PROMISES_OBJC_INSTALL_DIR}
rm -r ${PROMISES_OBJC_ARCHIVE_FILE}
mv ${PROMISES_OBJC_INSTALL_DIR}/PromisesObjC.xcframework-1.0.0 ${PROMISES_OBJC_INSTALL_DIR}/PromisesObjC.xcframework
echo "✅ Completed installing PromisesObjC.xcframework."

## NOTE: Xcode cloud上の環境でnodebrewのパスが間違っているからか、
## インストール後にnodebrewコマンドに失敗する

## Setup virtual Firebase project for tests
### install Node.js to use `npm` command
#brew install nodebrew
#nodebrew install-binary latest
### launch firestore emulator
#cd ../FirebaseTests
#npm install -g firebase-tools
#firebase setup:emulators:firestore
#firebase emulators:start --only firestore
