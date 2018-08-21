require 'yaml'
require_relative './version'

module GitSwitch
  class Switcher
    attr_reader :config, :profile, :global, :list, :valid_args

    def initialize(args)
      raise ArgumentError unless args.is_a? Array
      @config = load_config
      @global = check_global(args)
      @profile = get_profile(args)
      @valid_args = valid_args?(args)
      @list = check_list(args)
    end

    def run
      list ? print_list : set!
    end

    def load_config
      YAML.load_file(File.expand_path('~/.gitswitch')) || {}
    end

    def check_global(args)
      (args.include? '-g') || (args.include? '--global')
    end

    def check_list(args)
      (args.include? '-l') || (args.include? '--list')
    end

    def get_profile(args)
      # TODO: RCR - Verify profile exists in config file
      # TODO: RCR - Handle missing or empty config file
      args.detect {|a| !a.start_with? '-'}
    end

    def valid_args?(args)
      no_flags?(args) || one_flag?(args)
    end

    def no_flags?(args)
      args.length == 1 && args.count {|a| a.start_with? '-'} == 0
    end

    def one_flag?(args)
      args.length == 2 && args.count {|a| a.start_with?('-')} == 1
    end

    def set!
      return unless valid_args
      unless valid_profile
        puts "Profile '#{profile}' not found!"
        return
      end

      flag = global ? '--global' : ''

      puts "\nGit Config:"
      `git config #{flag} user.name "#{name}"`
      `git config #{flag} user.username "#{username}"`
      `git config #{flag} user.email "#{email}"`
      puts `git config #{flag} -l --show-origin | grep user`

      puts "\nSSH:"
      `ssh-add -D`
      `ssh-add #{ssh}`
      puts `ssh-add -l`
    end

    def print_list
      puts config.keys
    end

    def valid_profile
      config.has_key?(profile)
    end

    private

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
  end
end
