# require "git_switch/version"
require 'yaml'

class GitSwitch
  attr_reader :config, :profile
  # Your code goes here...
  def initialize
    # @profile = profile
    @config = YAML.load_file(File.expand_path('~/.gitswitch'))
  end

  # TODO: RCR - Add support for global vs local
  def set!(profile)
    @profile = profile
    # puts `git config -l`

    `git config --global user.name "#{name}"`
    `git config --global user.username "#{username}"`
    `git config --global user.email "#{email}"`
    puts `git config --global -l | grep user`
    `ssh-add -D`
    `ssh-add #{ssh}`
    puts `ssh-add -l`
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

switch = GitSwitch.new
if ARGV.length == 1
  switch.set!(ARGV.first)
else
  puts "Please provide the profile to use"
end
