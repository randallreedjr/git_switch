module GitSwitch
  class Options
    attr_reader :args
    def initialize(args)
      @args = args
    end

    def flags
      @flags ||= args.select do |arg|
        arg.match(/\A\-[glv]{1}\z/) ||
          arg.match(/\A\-\-(global|list|verbose){1}\z/)
      end
    end

    def valid_args?
      if list? && args.count > 1
        puts "Invalid args"
        return false
      elsif no_flags?(args) || one_flag?(args)
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

    def list?
      (flags.include? '-l') || (flags.include? '--list')
    end

    def global?
      (flags.include? '-g') || (flags.include? '--global')
    end

    def verbose?
      (flags.include? '-v') || (flags.include? '--verbose')
    end

    private

    def no_flags?(args)
      args.length == 1 && flag_count(args) == 0
    end

    def one_flag?(args)
      args.length == 2 && flag_count(args) == 1
    end

    def flag_count(args)
      args.count {|a| a.start_with? '-'}
    end
  end
end
