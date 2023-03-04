#!/bin/sh

# Carthage copy frameworks
/usr/local/bin/carthage copy-frameworks

# (少なくとも)9.6.0以降において FirebaseAnalytics に含まれるライブラリ PromisesObjC.xcframework は、
# CarthageでインストールするためにFirebase公式が用意したバイナリ中には含まれないため、手動インストールする。
# Archive
PROMISES_OBJC_ARCHIVE_FILE=https://github.com/shin-carpediem/PromisesObjC.xcframework/archive/refs/tags/1.0.0.zip
# Script
echo "🏃 PromisesObjC.xcframework has started been installing."
PROJECT_ROOT_DIR=$(cd ..;pwd)
PROMISES_OBJC_INSTALL_DIR=${PROJECT_ROOT_DIR}/Carthage
unzip -q -o ${PROMISES_OBJC_ARCHIVE_FILE} -d ${PROMISES_OBJC_INSTALL_DIR}
echo "✅ PromisesObjC.xcframework got completed been installing."
