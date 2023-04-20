![launch_screen](https://user-images.githubusercontent.com/71208265/207891766-de36b235-937b-404b-8ef8-7f793f3f37e7.png)

## App for Planning Poker

### Architecture

![VIPER_SwiftUI](https://user-images.githubusercontent.com/71208265/233383883-3fbfdeb4-05c6-47c0-b21c-992b07f23bd4.png)

### Package Dependency

#### Related to Builing App

| Package Manager                                | Package Name                                                            | Usage                                           |
| :--------------------------------------------- | :---------------------------------------------------------------------- | :---------------------------------------------- |
| [Xcode](https://developer.apple.com/jp/xcode/) | [swift-package-manager](https://github.com/apple/swift-package-manager) | Pakcage Manager for Packages Dependent with App |
| [Homebrew](https://brew.sh)                    | [swift-format](https://github.com/apple/swift-format)                   | Code Formatter                                  |

#### Dependent with App

| Package Manager                                                         | package Name                                                     | Usage           |
| :---------------------------------------------------------------------- | :--------------------------------------------------------------- | :-------------- |
| [swift-package-manager](https://github.com/apple/swift-package-manager) | [firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk) | Login, Database |
|                                                                         | [neumorphic](https://github.com/costachung/neumorphic)           | Neumorphism UI  |

#### How to Set up Project

- Install packages related to buidling the app by Homebrew.

```
$ brew install swift-format
```

- Add firebase's certificate named "GoogleService-Info-Dev.plist" for developing environment at the root of ${SRC_ROOT}/RemotePoker.

#### How to Upgrade Packages

Choose `Files` -> `Packages` -> `Update to Latest Package Versions`

#### How to Run Tests

```
$ cd firebase
```

```
$ firebase emulators:start --only firestore
```

#### How to Release App

- Make a tag, then all the test, archiving and uploading to App Store Connect will be done by Xcode Cloud.
