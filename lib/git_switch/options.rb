module GitSwitch
  class Options
    attr_reader :args
    def initialize(args)
      @args = args
    end

    def flags
      @flags ||= args.select do |arg|
        arg.match(/\A\-[cglv]{1}\z/) ||
          arg.match(/\A\-\-(config|global|list|verbose){1}\z/)
      end
    end

    def valid_args?
      if config_flag? && args.count == 1
        return true
      elsif list_flag? && args.count == 1
        return true
      elsif no_flags?
        return true
      elsif one_flag? && !flag_only?
        return true
      elsif usage?
        return true
      else
        puts "Invalid args"
        return false
      end
    end

    def usage?
      args.count == 0
    end

    def config?
      config_flag? && args.count == 1
    end

    def list?
      list_flag? && args.count == 1
    end

    def global?
      (flags.include? '-g') || (flags.include? '--global')
    end

    def verbose?
      (flags.include? '-v') || (flags.include? '--verbose')
    end

    private

    def list_flag?
      (flags.include? '-l') || (flags.include? '--list')
    end

    def config_flag?
      (flags.include? '-c') || (flags.include? '--config')
    end

    def no_flags?
      args.length == 1 && flag_count(args) == 0
    end

    def one_flag?
      args.length == 2 && flag_count(args) == 1
    end

    def flag_only?
      list_flag? || config_flag?
    end

    def flag_count(args)
      args.count {|a| a.start_with? '-'}
    end
  end
end
