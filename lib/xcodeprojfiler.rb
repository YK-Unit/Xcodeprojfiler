require 'thor'
require "xcodeprojfiler/version"
require 'xcodeprojfiler/command'

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

    desc "show_excluded_files", "Scan the current xcode project dir and find out the files which are not included in xcworkspace"
    long_desc <<-LONGDESC
      
      Scan the current xcode project directory and find out the files which are not included in xcworkspace

    LONGDESC
    def show_excluded_files
      Command.show_excluded_files
    end

  end

end
