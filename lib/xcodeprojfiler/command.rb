require 'xcodeproj'
require 'yaml'

module Xcodeprojfiler

  class Command
    def self.version
      version_desc = "#{Xcodeprojfiler::VERSION}"
      puts(version_desc)
    end

    # find_xclued_files  ->  xcluded_file_result_tuple
    #
    # 扫描当前目录，返回包含和不包含在xcworkspace的文件数组
    # 返回文件结果二元组 xcluded_file_result_tuple
    # xcluded_file_result_tuple = [included_file_array, excluded_file_array]
    #
    # @return [included_file_array, excluded_file_array]
    def self.find_xclued_files
      included_file_array = []
      excluded_file_array = []

      # 获取当前目录的 xcworkspace 文件路径
      root_dir = "#{Pathname::pwd}"
      xcworkspace_file = Dir.glob(["#{root_dir}/*.xcworkspace"]).first
      # xcworkspace_root_dir = "/Users/yorkfish/Workspace/Demo-Projects/TestGitFilter-OC"
      # xcworkspace_file = "/Users/yorkfish/Workspace/Demo-Projects/TestGitFilter-OC/TestGitFilter-OC.xcworkspace"

      if xcworkspace_file == nil
        puts("Xcodeprojfiler Error: not exited xcworkspace file: #{xcworkspace_file}")
        return [included_file_array, excluded_file_array]
      end

      puts("scan the current directory now ...")
      puts("")
      puts("PS: if the xcode project is very larger, Xcodeprojfiler needs more than 10min to scan")

      xcworkspace = Xcodeproj::Workspace.new_from_xcworkspace(xcworkspace_file)
      xcworkspace_file_references = xcworkspace.file_references

      xcworkspace_file_array = []
      xcworkspace_file_references.each do |file_ref|
        if file_ref.path != "Pods/Pods.xcodeproj"
          proj_absolute_path = "#{root_dir}/#{file_ref.path}"
          # puts("xcworkspace_project: #{proj_absolute_path}")
          proj = Xcodeproj::Project::open(proj_absolute_path)
          proj.files.each do  |pbx_file_ref|
            full_file_path = "#{proj.project_dir}/#{pbx_file_ref.full_path}"
            xcworkspace_file_array.push(full_file_path)
          end
        end
      end

      puts("")
      ignore_file_tips = <<-MESSAGE
PS: Xcodeprojfiler will ignore the following files:

  - fastlane/*
  - Pods/*
  - Podfile
  - Gemfile
  - .git/*
  - *.xcassets
  - *.xctemplate
  - *.framework
  - *.bundle
  - *.lock
  - *.py
  - *.rb
  - *.sh
  - *.log
  - *.config

      MESSAGE
      puts("#{ignore_file_tips}")

      all_files = Dir.glob(["#{root_dir}/**/*.*"])
      excluded_file_regex_array = [
        "#{root_dir}/**/*.xcodeproj/**/*",
        "#{root_dir}/**/*.xcworkspace/**/*",
        "#{root_dir}/**/*.xcassets/**/*",
        "#{root_dir}/**/*.xctemplate/**/*",
        "#{root_dir}/**/*.framework/**/*",
        "#{root_dir}/**/*.bundle/**/*",
        "#{root_dir}/**/.git/**/*",
        "#{root_dir}/**/fastlane/**/*",
        "#{root_dir}/**/Pods/**/*",
        "#{root_dir}/**/Podfile",
        "#{root_dir}/**/Gemfile",
        "#{root_dir}/**/*{.xcworkspace,.xcodeproj,.lproj,.xcassets,.xctemplate,.framework,.bundle,.lock,.rb,.py,.sh,.log,.config}"
      ]
      all_files = all_files - Dir.glob(excluded_file_regex_array)

      included_file_array = xcworkspace_file_array
      excluded_file_array =  all_files - included_file_array

      puts("")
      puts("scan the current directory done !!!")

      return [included_file_array, excluded_file_array]
    end

    # dump_excluded_files_to_file -> true
    #
    # 保存 excluded_file_array 到 excluded_files.yaml
    #
    def self.dump_excluded_files_to_file(excluded_file_array)
      root_dir = "#{Pathname::pwd}"
      yaml_file_path = "#{root_dir}/excluded_files.yaml"
      yaml_file = File.open(yaml_file_path, 'w')

      excluded_file_array.uniq!
      excluded_file_array.sort!
      yaml_content = {
        "excluded_files" => excluded_file_array
      }.to_yaml
      # remove three dashes (“---”).
      #
      # To get the details about three dashes (“---”)
      # see: https://yaml.org/spec/1.2/spec.html#id2760395
      #
      document_separate_maker = "---\n"
      regx = /\A#{document_separate_maker}/
      if yaml_content =~ regx
        yaml_content[document_separate_maker] = ""
      end

      yaml_file.write(yaml_content)
      yaml_file.close

      puts("")
      puts("to see the excluded files from: #{yaml_file_path}")
      return true
    end

    def self.show_excluded_files
      xcluded_file_result_tuple = self.find_xclued_files
      excluded_file_array = xcluded_file_result_tuple[1]
      dump_excluded_files_to_file(excluded_file_array)
    end
  end
end