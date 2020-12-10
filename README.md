# Xcodeprojfiler

Xcodeprojfiler is a CLI tooL which can help iOS developer to get the info of files which exist in the xcode project dir.

For example, Xcodeprojfiler can scan the current xcode project dir and find out the files which are not included in xcworkspace.


## Installation

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

# Describe available commands or one specific command
xcodeprojfiler help
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

