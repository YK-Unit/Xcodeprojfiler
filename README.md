# Xcodeprojfiler

Xcodeprojfiler is a CLI tooL which can help iOS developer to get the info of files which exist in the xcode project dir.

For example, Xcodeprojfiler can scan the current xcode project dir and find out the files which are not included in xcworkspace.

## Feature
- Support to show and delete(if you choose) the files which are not included in xcworkspace
- Support to show and delete(if you choose) the code files(`C/C++/Objective-C/Objective-C++/Swift/xib/storyboard`) which are not included in xcworkspace
- Support to tell xcodeprojfiler to ignore  the files which you want with customized regex

## Install & Update

```shell
sudo gem install xcodeprojfiler
```
## Usage

```shell
cd path/to/a-xcode-project-dir

# show the files which not included in xcworkspace 
xcodeprojfiler show_excluded_files

# show the code files(C/C++/Objective-C/Objective-C++/Swift/xib/storyboard) which not included in xcworkspace
xcodeprojfiler show_excluded_code_files

# show and delete the code files which not included in xcworkspace, except those in LocalComponent directory
xcodeprojfiler show_excluded_code_files --ignores "$(pwd)/LocalComponent/**/*" --delete

# show and delete the code files which not included in xcworkspace, except those in Pods and Fastlane directory
xcodeprojfiler show_excluded_code_files --ignores "$(pwd)/Pods/**/*" "$(pwd)/Fastlane/**/*" --delete

# Describe available commands or one specific command
xcodeprojfiler help
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

