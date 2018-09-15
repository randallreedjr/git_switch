require 'yaml'
require_relative './version'

module GitSwitch
  class Switcher
    attr_reader :config, :profile, :options

    def initialize(args)
      raise ArgumentError unless args.is_a? Array
      @config = load_config
      @options = GitSwitch::Options.new(args)
      @profile = get_profile(args)
    end

    def run
      list? ? print_list : set!
    end

    def list?
      options.list?
    end

    def global?
      options.global?
    end

    def get_profile(args)
      args.detect {|a| !a.start_with? '-'}
    end

    def valid_profile?
      if config.has_key?(profile)
        return true
      else
        puts "Profile '#{profile}' not found!"
        return false
      end
    end

    def git_repo?
      if GitHelper.git_repo? || global?
        return true
      else
        puts "Not a git repo. Please run from a git repo or run with `-g` to update global settings."
        return false
      end
    end

    def set!
      return unless options.valid_args? && valid_profile?
      return unless git_repo?

      flag = global? ? '--global' : ''

      set_git_config(flag)
      set_ssh
    end

    def print_list
      profiles = config.map do |key, value|
        prefix = value["username"] == current_git_username ? "=>" : "  "
        "#{prefix} #{key}"
      end
      puts profiles
      puts "\n# => - current" if config.any? {|key, value| value["username"] == current_git_username}
    end

    private

    def load_config
      # TODO: RCR - Handle missing or empty config file
      YAML.load_file(File.expand_path('~/.gitswitch')) || {}
    end

    def current_git_username
      `git config user.username`.chomp
    end

    def name
      config[profile]["name"]
    end

    def username
      config[profile]["username"]
    end

    def email
      config[profile]["email"]
    end

    def ssh
      config[profile]["ssh"]
    end

    def set_git_config(flag)
      puts "\nGit Config:"
      `git config #{flag} user.name "#{name}"`
      `git config #{flag} user.username "#{username}"`
      `git config #{flag} user.email "#{email}"`
      puts `git config #{flag} -l --show-origin | grep user`
    end

    def set_ssh
      puts "\nSSH:"
      `ssh-add -D`
      `ssh-add #{ssh}`
      puts `ssh-add -l`
    end
  end
end
