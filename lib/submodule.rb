require "submodule/version"

require "rake/tasklib"
require "inifile"

module Submodule
  class Task < ::Rake::TaskLib

    attr_reader :path

    def initialize
      @cwd = Dir.pwd

      base = File.basename Dir["*.gemspec"][0], ".gemspec"
      if base[0]  
        base = File.basename Dir["*.gemspec"][0], ".gemspec"
        @version_file = "lib/#{base}/version.rb"
      end

      gitmodules = IniFile.new('./.gitmodules').to_h
      @path = gitmodules[gitmodules.keys.first]["path"]
      @submodule_name = gitmodules.keys.first
        .gsub('submodule ', '')
        .gsub('"', '')
        .gsub('vendor/', '')
      @github = gitmodules[gitmodules.keys.first]["url"]
        .gsub('https://github.com/', '')
        .gsub('.git', '')
      define 
    end

    def test
      p "define tests in test function"
    end

    def after_pull
      p "after pull"
    end

    private

    def define
      desc "Update, test and commit submodule #{@submodule_name}"
      task "submodule:update" do
        git_update
        cd path
        hash_before = git_hash
        git_pull
        hash_after = git_hash
        if hash_before == hash_after
          abort "submodule #{@submodule_name} already up-to-date"
        end
        test
        update_version hash_after
        cd @cwd
        git_add
        after_pull
        git_commit hash_after
      end
      desc "Test submodule #{@submodule_name}"
      task "submodule:test" do
        git_update
        cd path
        test
        cd @cwd
      end
      self
    end

    def git_update
      sh "git submodule update --init --recursive"
    end

    # def my_sh cmd
    #   puts cmd
    #   res = `#{cmd}`
    #   if $? != 0
    #     abort "Running `#{cmd}' failed. Run this command directly for more detailed output"
    #   end
    #   res
    # end

    def git_pull
      sh "git clean -f"
      sh "git checkout master"
      sh "git pull"
      # res = my_sh "git pull"
      # if res =~ /Already up-to-date/
      #   p res
      #   abort "submodule #{@submodule_name} already up-to-date"
      # end
    end

    def git_hash
      `git rev-parse --verify HEAD`.strip
      # http://git-scm.com/book/en/ch2-3.html Table 2-1
      # {
      #   hash: `git rev-parse --verify HEAD`.strip,
      #   short_hash: ` git log -1 --pretty=format:"%h"`,
      #   commit_date: ` git log -1 --pretty=format:"%cd"`,
      #   comment: ` git log -1 --pretty=format:"%s"`
      # }
    end

    def git_add
      sh "git add " + path
      sh "git add " + @version_file
    end

    def version_path
      File.expand_path(@version_file, @cwd)
    end

    def version_regexp val = "(.*)", re = true
      str = "VERSION = \"#{val}\""
      if re
        Regexp.new str.gsub(" ", "\s*")
      else
        str
      end
    end

    def submodule_regexp val = "(.*)", re = true
      str = "SUBMODULE = \"#{val}\""
      if re
        Regexp.new str.gsub(" ", "\s*")
      else
        str
      end
    end

    def update_version hash
      if File.file? version_path
        version_info = File.read version_path
        version_number = version_regexp.match(version_info)[1]
        version_number = version_number.split('.')
        # TODO not update if current version not commited yet
        version_number[2] = version_number[2].to_i + 1
        version_number = version_number.join('.')

        version_info.gsub! version_regexp, version_regexp(version_number, false)
        version_info.gsub! submodule_regexp, submodule_regexp(hash, false)

        File.open version_path, "w" do |f|
          f.write version_info
        end
      else
        p "no version file"
      end
    end

    def git_commit hash
      message = "update #{@submodule_name} to #{@github}@#{hash}"
      sh "git commit -m \"#{message}\""
    end

  end
end
