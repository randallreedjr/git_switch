require 'yaml'
require_relative './version'

module GitSwitch
  class Switcher
    attr_reader :args, :config, :profile, :global, :list

    def initialize(args)
      raise ArgumentError unless args.is_a? Array
      @args = args
      @config = load_config
      @global = check_global(args)
      @profile = get_profile(args)
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

    def valid_args?
      if check_list(args) && args.count > 1
        puts "Invalid args"
        return false
      elsif no_flags?(args) || one_flag?(args)
        return true
      else
        puts "Invalid args"
        return false
      end
    end

    def valid_profile?
      if config.has_key?(profile)
        return true
      else
        puts "Profile '#{profile}' not found!"
        return false
      end
    end

    def no_flags?(args)
      args.length == 1 && flag_count(args) == 0
    end

    def one_flag?(args)
      args.length == 2 && flag_count(args) == 1
    end

    def flag_count(args)
      args.count {|a| a.start_with? '-'}
    end

    def set!
      return unless valid_args? && valid_profile?

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
