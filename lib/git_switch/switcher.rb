require_relative './version'
require 'active_support/core_ext/module/delegation'

module GitSwitch
  class Switcher
    attr_reader :config, :options
    delegate :usage?, :config?, :list?, :global?, to: :options
    delegate :profile, :name, :username, :email, :ssh, :print_list, :configure!, :valid_profile?, to: :config

    def initialize(args)
      raise ArgumentError unless args.is_a? Array
      @options = GitSwitch::Options.new(args)
      @config = GitSwitch::Config.new(args)
    end

    def run
      return unless options.valid_args?
      if usage?
        print_usage
      elsif config?
        configure!
      elsif list?
        print_list
      else
        set!
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
      return unless valid_profile? && git_repo?

      flag = global? ? '--global' : ''

      set_git_config(flag)
      set_ssh
      print_settings(flag)
    end

    def print_usage
      puts usage
    end

    def print_settings(flag = '')
      if options.verbose?
        puts "\nGit Config:"
        puts `git config #{flag} -l --show-origin | grep user`
        puts "\nSSH:"
        puts `ssh-add -l`
      else
        puts "Switched to profile #{profile}"
      end
    end

    private

    def set_git_config(flag)
      `git config #{flag} user.name "#{name}"`
      `git config #{flag} user.username "#{username}"`
      `git config #{flag} user.email "#{email}"`
    end

    def set_ssh
      `ssh-add -D`
      `ssh-add #{ssh}`
    end

    def usage
      <<~USAGE
      usage: git switch [-l | --list] [-c | --config]
                        <profile> [-v | --verbose] [-g | --global]

      configure profiles
          git switch -c

      switch to a profile for local development only
          git switch <profile>

      switch to a profile globally
          git switch -g <profile>

      switch to a profile and see all output
          git switch -v <profile>

      see available profiles
          git switch -l
      USAGE
    end
  end
end
