require 'yaml'

module GitSwitch
  class Config
    attr_reader :profiles, :selected_profile
    def initialize(args)
      @profiles = load!
      @args = args
      @selected_profile = get_profile(args)
    end

    def get_profile(args)
      args.detect {|a| !a.start_with? '-'}
    end

    def name
      profiles[selected_profile]["name"]
    end

    def username
      profiles[selected_profile]["username"]
    end

    def email
      profiles[selected_profile]["email"]
    end

    def ssh
      profiles[selected_profile]["ssh"]
    end

    def profile
      @selected_profile
    end

    def valid_profile?
      if profiles.has_key?(selected_profile)
        return true
      else
        puts "Profile '#{selected_profile}' not found!"
        return false
      end
    end

    def print_list
      profiles = @profiles.map do |key, value|
        prefix = value["username"] == current_git_username ? "=>" : "  "
        "#{prefix} #{key}"
      end
      puts profiles
      puts "\n# => - current" if @profiles.any? {|key, value| value["username"] == current_git_username}
    end

    private

    def load!
      # TODO: RCR - Handle missing or empty config file
      YAML.load_file(File.expand_path('~/.gitswitch')) || {}
    end

    def current_git_username
      `git config user.username`.chomp
    end
  end
end
