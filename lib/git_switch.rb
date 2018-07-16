# require "git_switch/version"
require 'yaml'

class GitSwitch
  # Your code goes here...
  def set(username)
    # puts `git config -l`
    config = YAML.load_file(File.expand_path('~/.gitswitch'))
    `git config user.name "#{config[username]["name"]}"`
    `git config user.username "#{config[username]["username"]}"`
    `git config user.email "#{config[username]["email"]}"`
  end
end

switch = GitSwitch.new
if ARGV.length == 1
  switch.set(ARGV.first)
else
  puts "Please provide the profile to use"
end
