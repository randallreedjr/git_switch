require "bundler/setup"
require "git_switch"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:each) do
    allow(File).to receive(:expand_path).and_call_original
    allow(File).to receive(:expand_path).with('~/.gitswitch').and_return(File.expand_path('spec/fixtures/.gitswitch'))
  end
end
