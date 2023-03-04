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

echo "🏃 PromisesObjC.xcframework has started been installing."
curl -L ${PROMISES_OBJC_ARCHIVE_URL} --output ${PROMISES_OBJC_ARCHIVE_FILE}
unzip -q -o ${PROMISES_OBJC_ARCHIVE_FILE} -d ${PROMISES_OBJC_INSTALL_DIR}
rm -r ${PROMISES_OBJC_ARCHIVE_FILE}
mv ${PROMISES_OBJC_INSTALL_DIR}/PromisesObjC.xcframework-1.0.0 ${PROMISES_OBJC_INSTALL_DIR}/PromisesObjC.xcframework
echo "✅ PromisesObjC.xcframework got completed been installing."
