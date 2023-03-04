#!/bin/sh

# Carthage copy frameworks
/usr/local/bin/carthage copy-frameworks

# FirebaseAnalyticsに用いられるライブラリ PromisesObjC.xcframework は
# Carthage経由ではインストールされないため、別の方法でインストールする。
