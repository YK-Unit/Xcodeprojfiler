lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xcodeprojfiler/version"

Gem::Specification.new do |spec|
  spec.name          = "xcodeprojfiler"
  spec.version       = Xcodeprojfiler::VERSION
  spec.authors       = ["York"]
  spec.email         = ["yorkzhang520@gmail.com"]

  spec.summary       = "A CLI TooL which can help iOS developer to get the info of files which exist in the xcode project dir"
  spec.description   = "Xcodeprojfiler is a CLI tooL which can help iOS developer to get the info of files which exist in the xcode project dir.
For example, Xcodeprojfiler can scan the current xcode project dir and find out the files which are not included in xcworkspace."
  spec.homepage      = "https://github.com/YK-Unit/Xcodeprojfiler"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["xcodeprojfiler"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bundler", "~> 2.0", '>= 2.0.2'
  spec.add_runtime_dependency "thor", "~> 1.0", '>= 1.0.1'
  spec.add_runtime_dependency "xcodeproj", "~> 1.0", '>= 1.9.0'
end
