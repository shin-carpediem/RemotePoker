#!/bin/sh

# install packages related to buidling app by Homebrew
brew install carthage
brew install swift-format

# build packages installed by Cathage and make cache for upcoming app build
PROJECT_ROOT_DIR=$(cd ..;pwd)
carthage bootstrap --platform iOS --cache-builds --use-xcframeworks --no-use-binaries --project-directory ${PROJECT_ROOT_DIR}

# apply environment variables set on Xcode Cloud
GOOGLESERVICE_INFO_PRODUCTION_FILE_PATH="${PROJECT_ROOT_DIR}/RemotePoker/GoogleService-Info.plist"
plutil -replace "API_KEY" -string ${GOOGLESERVICE_INFO_PRODUCTION_API_KEY} ${GOOGLESERVICE_INFO_PRODUCTION_FILE_PATH}
