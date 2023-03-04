![launch_screen](https://user-images.githubusercontent.com/71208265/207891766-de36b235-937b-404b-8ef8-7f793f3f37e7.png)

## App for Planning Poker

### Architecture

![VIPER_SwiftUI](https://user-images.githubusercontent.com/71208265/222874483-777408a0-1b17-4ffb-80ba-ee4a8b6625c5.png)

### Package Dependency

#### Related to Builing App

| Package Manager             | Package Name                                          | Usage                                           |
| :-------------------------- | :---------------------------------------------------- | :---------------------------------------------- |
| [Homebrew](https://brew.sh) | [Carthage](https://github.com/Carthage/Carthage)      | Pakcage Manager for Packages Dependent with App |
|                             | [swift-format](https://github.com/apple/swift-format) | Code Formatter                                  |

#### Dependent with App

| Package Manager                                                         | package Name                                                      | Usage             |
| :---------------------------------------------------------------------- | :---------------------------------------------------------------- | :---------------- |
| [swift-package-manager](https://github.com/apple/swift-package-manager) | [LoaderUI](https://github.com/ninjaprox/LoaderUI)                 | Loading Animation |
|                                                                         | [neumorphic](https://github.com/costachung/neumorphic)            | Neumorphism UI    |
| [Carthage](https://github.com/Carthage/Carthage)                        | [FirebaseAnalytics](https://github.com/firebase/firebase-ios-sdk) | Data Analysis     |
|                                                                         | [FirebaseAuth](https://github.com/firebase/firebase-ios-sdk)      | Anonimous Login   |
|                                                                         | [FirebaseFirestore](https://github.com/firebase/firebase-ios-sdk) | Database          |

#### How to Set up Project

- Install packages related to buidling the app by Homebrew.

```
$ brew install carthage
```

```
$ brew install swift-format
```

- Build packages installed by Carthage and make cache for upcoming building iOS app at root of the project.

- If you have already installed some packages by Carthage, delete them.

```
$ rm -r Carthage

```

```
$ carthage bootstrap --platform iOS --cache-builds --use-xcframeworks --no-use-binaries
```

#### How to upgrade packages

```
$ carthage update --platform iOS --cache-builds --use-xcframeworks --no-use-binaries
```

#### How to Release App

- Make a tag, then all the test, archiving and uploading to App Store Connect will be done by Xcode Cloud.
