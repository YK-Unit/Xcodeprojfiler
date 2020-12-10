## Xcodeprojfiler Cli Deployment Check List

1. 确定Deployment的版本号：X.Y.Z
1. 编辑`lib/xcodeprojfiler/version.rb`，更新`VERSION`：

	```ruby
	module Xcodeprojfiler
    		VERSION = "X.Y.Z"
    		...
	end
	```
1.  更新CHANGELOG.md
1. 在项目根目录下运行脚本更新Gemfile：`bundle exec ./bin/xcodeprojfiler`
1. 提交当前变更到git
1. 在项目根目录下运行脚本打包Gem：`gem build xcodeprojfiler.gemspec`
1. 本地安装`Xcodeprojfiler`进行测试：`sudo gem install xcodeprojfiler-x.y.z.gem`
1. 若无问题，则发布`Xcodeprojfiler`到RubyGems市场

## Publish Xcodeprojfiler Cli

1. 在项目根目录下运行脚本发布`Xcodeprojfiler`：`gem push xcodeprojfiler-x.y.z.gem`

## Other

1. 从RubyGems市场下架指定版本的`Xcodeprojfiler`：`gem yank xcodeprojfiler -v x.y.z`

