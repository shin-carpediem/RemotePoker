#!/bin/sh

# Carthage copy frameworks
/usr/local/bin/carthage copy-frameworks

# (少なくとも)9.6.0以降において FirebaseAnalytics に含まれるライブラリ PromisesObjC.xcframework は、
# CarthageでインストールするためにFirebase公式が用意したバイナリ中には含まれないため、手動インストールする。
cd ../bin
./install_promisesobjc.sh
