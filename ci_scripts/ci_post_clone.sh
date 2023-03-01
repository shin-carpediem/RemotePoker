#!/bin/sh

# install packages related to buidling app by Homebrew
brew install carthage
brew install swift-format

# build packages installed by Cathage and make cache for upcoming app build
carthage update --platform iOS --cache-builds --use-xcframeworks --project-directory ../Users/aokishinichiro/develop/Scrumdinger
