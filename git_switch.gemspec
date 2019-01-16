
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git_switch/version"

Gem::Specification.new do |spec|
  spec.name          = "git_switch"
  spec.version       = GitSwitch::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Randall Reed, Jr."]
  spec.email         = ["randallreedjr@gmail.com"]

  spec.summary       = %q{Switch between git profiles}
  spec.description   = %q{Easily switch between git profiles (name, username, email) and ssh keys}
  spec.homepage      = "https://www.github.com/randallreedjr/git_switch"
  spec.license       = "MIT"

  spec.files = [
    'lib/git_switch.rb',
    'lib/git_switch/switcher.rb',
    'lib/git_switch/git_helper.rb',
    'lib/git_switch/config.rb',
    'lib/git_switch/options.rb',
    'lib/git_switch/version.rb',
    'bin/git-switch'
  ]

  spec.executables   << 'git-switch'
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 5.2.2"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4.1"
  spec.add_development_dependency "pry"
end
