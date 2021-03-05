require 'thor'
require "xcodeprojfiler/version"
require 'xcodeprojfiler/command'
require 'xcodeprojfiler/string_extensions'

module Xcodeprojfiler

  class CLI < Thor

    def self.help(shell, subcommand = false, display_introduction = true)
      introduction = <<-MESSAGE
Xcodeprojfiler is a CLI tooL which can help iOS developer to get the info of files which exist in the xcode project dir.
For example, Xcodeprojfiler can scan the current xcode project dir and find out the files which are not included in xcworkspace.

      MESSAGE
      if display_introduction
        puts(introduction)
      end
      super(shell,subcommand)
    end

    def self.exit_on_failure?
      puts("")
      help(CLI::Base.shell.new, false, false)
      true
    end

    desc "version", "Display version"
    long_desc <<-LONGDESC
      Display the version of Xcodeprojfiler.
    LONGDESC
    def version
      Command.version
    end
    map %w[-v --version] => :version

    desc "show_excluded_files [--ignores] [--delete]", "show and delete(if you choose) the files which not included in xcworkspace"
    long_desc <<-LONGDESC
      
      #{"With no option".bold}, #{"Xcodeprojfiler".bold} will scan the current xcode project directory and find out the files which not included in xcworkspace.

      #{"With".bold} #{"--ignores".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold} will ignore the files which match the any ignored regular expression.

      #{"With".bold} #{"--delete".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold}  will delete the excluded files after scan done.

      #{"Example:".red.bold}

        # show and delete the files which not included in xcworkspace, except those in Pods and Fastlane directory

        xcodeprojfiler show_excluded_files #{"--ignores".red} "$(pwd)/Pods/**/*" "$(pwd)/Fastlane/**/*" #{"--delete".red}

    LONGDESC
    option :delete, :type => :boolean, :default => false
    option :ignores, :type => :array, :default => []
    def show_excluded_files
      should_delete = options[:delete]
      ignored_regex_array = options[:ignores]

      Command.show_excluded_files(should_delete, ignored_regex_array)
    end

    desc "show_excluded_code_files [--ignores] [--delete]", "show and delete(if you choose) the code files(C/C++/Objective-C/Objective-C++/Swift/xib/storyboard) which not included in xcworkspace"
    long_desc <<-LONGDESC
      #{"With no option".bold}, #{"Xcodeprojfiler".bold} will scan the current xcode project directory and find out the code files(C/C++/Objective-C/Objective-C++/Swift/xib/storyboard) which not included in xcworkspace.

      #{"With".bold} #{"--ignores".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold} will ignore the files which match the any ignored regular expression.

      #{"With".bold} #{"--delete".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold}  will delete the excluded code files after scan done.

      #{"Example:".red.bold}

        # show and delete the code files which not included in xcworkspace, except those in Pods and Fastlane directory

        xcodeprojfiler show_excluded_files #{"--ignores".red} "$(pwd)/Pods/**/*" "$(pwd)/Fastlane/**/*" #{"--delete".red}

    LONGDESC
    option :delete, :type => :boolean, :default => false
    option :ignores, :type => :array, :default => []
    def show_excluded_code_files
      should_delete = options[:delete]
      ignored_regex_array = options[:ignores]

      Command.show_excluded_code_files(should_delete, ignored_regex_array)
    end

    desc "show_included_files [--ignores]", "show the files which is included in xcworkspace"
    long_desc <<-LONGDESC
      
      #{"With no option".bold}, #{"Xcodeprojfiler".bold} will scan the current xcode project directory and find out the files which not included in xcworkspace.

      #{"With".bold} #{"--ignores".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold} will ignore the files which match the any ignored regular expression.

      #{"Example:".red.bold}

        # show the files which is included in xcworkspace, except those in Pods and Fastlane directory

        xcodeprojfiler show_excluded_files #{"--ignores".red} "$(pwd)/Pods/**/*" "$(pwd)/Fastlane/**/*" #{"--delete".red}

    LONGDESC
    option :ignores, :type => :array, :default => []
    def show_included_files
      ignored_regex_array = options[:ignores]

      Command.show_included_files(ignored_regex_array)
    end

    desc "show_included_binary_files [--ignores] [--supported_arch_types] [--unsupported_arch_types]", "show the binary files which is included in xcworkspace"
    long_desc <<-LONGDESC
      
      #{"With no option".bold}, #{"Xcodeprojfiler".bold} will scan the current xcode project directory and find out the files which not included in xcworkspace.

      #{"With".bold} #{"--ignores".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold} will ignore the files which match the any ignored regular expression.

      #{"With".bold} #{"--supported_arch_types".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold} will filter the binary files which supported the specific arch types.

      #{"With".bold} #{"--unsupported_arch_types".red.bold} #{"option".bold}, #{"Xcodeprojfiler".bold} will filter the binary files which not supported the specific arch types.

      #{"Example:".red.bold}

        # show the files which is included in xcworkspace, except those in Pods and Fastlane directory

        xcodeprojfiler show_included_binary_files #{"--ignores".red} "$(pwd)/Pods/**/*" "$(pwd)/Fastlane/**/*" #{"--delete".red}

    LONGDESC
    option :ignores, :type => :array, :default => []
    def show_included_files
      ignored_regex_array = options[:ignores]
      supported_arch_type_arry = options[:supported_arch_types]
      unsupported_arch_type_arry = options[:unsupported_arch_types]

      Command.show_included_binary_files(ignored_regex_array, supported_arch_type_arry, unsupported_arch_type_arry)
    end
  end

end
