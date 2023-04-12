#!/bin/sh

## NOTE: Xcode cloud上の環境でnodebrewのパスが間違っているからか、
## インストール後にnodebrewコマンドに失敗する

## Setup virtual Firebase project for tests
### install Node.js to use `npm` command
#brew install nodebrew
#nodebrew install-binary latest
### launch firestore emulator
#cd ../firebase
#npm install -g firebase-tools
#firebase setup:emulators:firestore
#firebase emulators:start --only firestore
