#!/bin/sh

# install packages related to buidling app by Homebrew
brew install swift-format

# apply environment variables set on Xcode Cloud
PROJECT_ROOT_DIR=$(cd ..;pwd)
GOOGLESERVICE_INFO_PRODUCTION_FILE_PATH="${PROJECT_ROOT_DIR}/RemotePoker/GoogleService-Info.plist"
GOOGLESERVICE_INFO_DEVELOPMENT_FILE_PATH="${PROJECT_ROOT_DIR}/RemotePoker/GoogleService-Info-Dev.plist"
plutil -replace "API_KEY" -string ${GOOGLESERVICE_INFO_PRODUCTION_API_KEY} ${GOOGLESERVICE_INFO_PRODUCTION_FILE_PATH}
plutil -replace "API_KEY" -string ${GOOGLESERVICE_INFO_DEVELOPMENT_API_KEY} ${GOOGLESERVICE_INFO_DEVELOPMENT_FILE_PATH}
