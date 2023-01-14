![launch_screen](https://user-images.githubusercontent.com/71208265/207891766-de36b235-937b-404b-8ef8-7f793f3f37e7.png)

## App for Planning Poker

### Architecture

![VIPER_SwiftUI](https://user-images.githubusercontent.com/71208265/207720255-8bf04fee-8693-4b2e-ad72-fdc26d361159.png)

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

#### How to Set up

- install packages related to buidling app by Homebrew

```
$ brew install carthage
```

```
$ brew install swift-format
```

- build packages installed by Cathage and make cache for upcoming app build

```
$ carthage update --platform iOS
```
