require 'xcodeproj'
require 'yaml'
require 'xcodeprojfiler/string_extensions'

module Xcodeprojfiler

  class Command
    def self.version
      version_desc = "#{Xcodeprojfiler::VERSION}"
      puts(version_desc)
    end

    def self.show_common_tips_before_scan
      puts("")
      puts("PS: If the xcode project is very large, Xcodeprojfiler needs more than 5min to scan")
      puts("")
      ignore_file_tips = <<-MESSAGE
PS: Xcodeprojfiler do ignore the following files:

  - fastlane/*
  - Pods/*
  - Podfile
  - Gemfile
  - .git/*
  - *.xctemplate
  - *.lock
  - *.py
  - *.rb
  - *.sh
  - *.log
  - *.config
  - *.properties

      MESSAGE
      puts("#{ignore_file_tips}")
    end

    # find_xclued_files  ->  xcluded_file_result_tuple
    #
    # 扫描当前目录，返回包含和不包含在xcworkspace的文件数组
    # 返回文件结果二元组 xcluded_file_result_tuple
    # xcluded_file_result_tuple = [included_file_array, excluded_file_array]
    #
    # @return [included_file_array, excluded_file_array]
    def self.find_xclued_files(ignored_regex_array)
      included_file_array = []
      excluded_file_array = []

      # 获取当前目录的 xcworkspace 文件路径
      root_dir = "#{Pathname::pwd}"
      xcworkspace_file = Dir.glob(["#{root_dir}/*.xcworkspace"]).first
      # xcworkspace_root_dir = "/Users/yorkfish/Workspace/Demo-Projects/TestGitFilter-OC"
      # xcworkspace_file = "/Users/yorkfish/Workspace/Demo-Projects/TestGitFilter-OC/TestGitFilter-OC.xcworkspace"

      if xcworkspace_file == nil
        puts("")
        puts("[!] No xcworkspace file found in the current working directory".red)
        return [included_file_array, excluded_file_array]
      end

      puts("")
      puts("scan the current working directory now ...")

      xcworkspace = Xcodeproj::Workspace.new_from_xcworkspace(xcworkspace_file)
      xcworkspace_file_references = xcworkspace.file_references

      # TODO: 需要设置成是否忽略"Pods/Pods.xcodeproj"
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
        "#{root_dir}/**/*{.git,.xcworkspace,.xcodeproj,.lproj,.xctemplate,.lock,.rb,.py,.sh,.log,.config,.properties}"
      ]
      all_files = all_files - Dir.glob(excluded_file_regex_array)

      if ignored_regex_array.empty? == false
        puts("")
        puts("Xcodeprojfiler will ignore the following files which you specify:")
        puts("")
        ignored_regex_array.each do |regex|
          puts("  - #{regex}")
        end
        all_files = all_files - Dir.glob(ignored_regex_array)
      end

      included_file_array = xcworkspace_file_array
      excluded_file_array =  all_files - included_file_array

      puts("")
      puts("scan the current working directory done !!!")

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

    # dump_yaml_obj_to_file -> true
    #
    # 保存 yaml_obj 到 yaml_file_path
    #
    def self.dump_yaml_obj_to_file(yaml_obj, yaml_file_path)
      yaml_file = File.open(yaml_file_path, 'w')

      yaml_content = yaml_obj.to_yaml
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
      puts("to see the result files from: #{yaml_file_path}")
      return true
    end

    def self.show_excluded_files(shouldDelete, ignored_regex_array)
      self.show_common_tips_before_scan
      xcluded_file_result_tuple = self.find_xclued_files(ignored_regex_array)
      excluded_file_array = xcluded_file_result_tuple[1]

      if shouldDelete
        puts("")
        puts("delete the excluded files now ...")
        FileUtils.rm_rf(excluded_file_array)
        puts("")
        puts("delete the excluded files done !!!")
      end

      dump_excluded_files_to_file(excluded_file_array)
    end

    def self.show_excluded_code_files(shouldDelete, ignored_regex_array)
      self.show_common_tips_before_scan

      code_file_types = [
        ".h",
        ".c",
        ".cpp",
        ".m",
        ".mm",
        ".swift",
        ".a",
        ".framework",
        ".xib",
        ".storyboard",
      ]

      puts("")
      puts("PS: Xcodeprojfiler will show and delete(if you choose) the following code files:")
      puts("")
      code_file_types.each do |code_file_type|
        puts("  - *#{code_file_type}")
      end

      xcluded_file_result_tuple = self.find_xclued_files(ignored_regex_array)
      excluded_file_array = xcluded_file_result_tuple[1]
      excluded_code_file_array = excluded_file_array.select do |file|
        file_extname = File.extname(file)
        if code_file_types.include?(file_extname)
          next true
        end
      end

      if shouldDelete
        puts("")
        puts("delete the excluded files now ...")
        FileUtils.rm_rf(excluded_code_file_array)
        puts("")
        puts("delete the excluded files done !!!")
      end

      dump_excluded_files_to_file(excluded_code_file_array)
    end

    def self.show_included_files(ignored_regex_array)
      self.show_common_tips_before_scan
      xcluded_file_result_tuple = self.find_xclued_files(ignored_regex_array)
      included_file_array = xcluded_file_result_tuple[0]

      yaml_obj = {
        "included_files" => included_file_array
      }
      root_dir = "#{Pathname::pwd}"
      yaml_file_path = "#{root_dir}/included_files.yaml"

      dump_yaml_obj_to_file(yaml_obj,yaml_file_path)
    end

    def self.show_included_binary_files(ignored_regex_array, supported_arch_type_arry, unsupported_arch_type_arry)
      self.show_common_tips_before_scan
      xcluded_file_result_tuple = self.find_xclued_files(ignored_regex_array)
      included_file_array = xcluded_file_result_tuple[0]

      included_binary_file_array = included_file_array

      yaml_obj = {
        "included_binary_files" => included_binary_file_array
      }

      root_dir = "#{Pathname::pwd}"
      yaml_file_path = "#{root_dir}/included_binary_files.yaml"

      dump_yaml_obj_to_file(yaml_obj,yaml_file_path)
    end


  end
end