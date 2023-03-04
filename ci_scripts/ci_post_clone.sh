#!/bin/sh

# install packages related to buidling app by Homebrew
brew install carthage
brew install swift-format

# build packages installed by Cathage and make cache for upcoming app build
PROJECT_ROOT_DIR=$(cd ..;pwd)
carthage update --platform iOS --cache-builds --use-xcframeworks --project-directory ${PROJECT_ROOT_DIR}
