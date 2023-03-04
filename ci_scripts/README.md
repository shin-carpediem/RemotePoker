## Xcode Cloud / Create a custom build script

When Xcode Cloud performs an action you’ve added to a workflow, it performs a series of steps. If you add a custom build script, Xcode Cloud runs it at a specific moment between these steps.
The name of a custom script’s corresponding file determines when Xcode Cloud runs the script; only use the following file names for your scripts:

#### ci_post_clone.sh
  - The post-clone script runs after Xcode Cloud clones your Git repository. You might use a post-clone script to install an additional tool, or to add a new entry to a property list.

#### ci_pre_xcodebuild.sh
  - The pre-xcodebuild script runs before Xcode Cloud runs the xcodebuild command. You might use a pre-xcodebuild script to compile additional dependencies.

#### ci_post_xcodebuild.sh
  - The post-xcodebuild script runs after Xcode Cloud runs the xcodebuild command — even if the xcodebuild command fails. You might use a post-xcodebuild script to upload artifacts to storage or another service.

### [Detail](https://developer.apple.com/documentation/xcode/writing-custom-build-scripts)
