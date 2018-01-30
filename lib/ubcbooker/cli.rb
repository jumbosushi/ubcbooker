module Ubcbooker
  class CLI
    attr_accessor :options

    # What happens if I'm already logged in here?
    # Maybe check by seeing if the CWL link pops up after GET
    def initialize
      @config = Ubcbooker::Config.new
    end

    def ask_config
      print "Your CWL username: "
      username = gets.chomp
      print "Your CWL password: "
      # Hide the password input
      password = STDIN.noecho(&:gets).chomp
      @config.write(username, password)
      puts
    end

    def is_valid_department(d)
      return BOOKING_URL.keys.include?(d.to_sym)
    end

    def parse_options
      # This will hold the options we parse
      options = {
        save: false,
        update: false,
        department: nil,
      }

      OptionParser.new do |parser|
        parser.on("-d", "--department <DEPARTMENT>", "Specify which department to book rooms from") do |v|
          if is_valid_department(v)
            options[:department] = v
          else
            raise Ubcbooker::Error::UnsupportedDepartment.new(v)
          end
        end

        parser.on("-h", "--help", "Show this help message") do ||
          puts parser
          exit(0)
        end

        parser.on("-l", "--list", "List supported departments") do ||
          @config.print_supported_departments
          exit(0)
        end

        parser.on("-s", "--save", "Save username and password") do |v|
          options[:save] = true
        end

        parser.on("-u", "--update", "Update username and password") do |v|
          options[:update] = true
        end

        parser.on("-v", "--version", "Show version") do ||
          puts Ubcbooker::VERSION
          exit(0)
        end
      end.parse!

      return options
    end

    def get_options
      begin
        return parse_options
      rescue Ubcbooker::Error::UnsupportedDepartment => e
        puts "\"#{e.department}\" is an unsupported department\n".red <<
          "Check supported departments with `ubcbooker -l`".brown
      rescue OptionParser::MissingArgument
        puts "Missing a department option\n".red <<
          "Try calling with `ubcbooker -d <DEPARTMENT>`\n".brown <<
          "Check supported departments with `ubcbooker -l`".brown
      end
      exit(1)
    end

    def start
      @options = get_options
      if !@config.defined? || @options[:update]
        ask_config
      end

      @client = Ubcbooker::Http.new(@config.username, @config.password)
      @client.book(@options[:department])
    end
  end
end
