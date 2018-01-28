module Ubcbooker
  class CLI
    attr_accessor :username, :password

    # What happens if I'm already logged in here?
    # Maybe check by seeing if the CWL link pops up after GET
    def initialize
      @app_config = Ubcbooker::Config.new
    end

    def ask_config
      print "CWL username: "
      username = gets.chomp
      print "CWL password: "
      # Hide the password input
      password = STDIN.noecho(&:gets).chomp
      @app_config.write(username, password)
      puts
    end

    def parse_options
      # This will hold the options we parse
      options = {
        save: false,
        department: nil,
      }

      OptionParser.new do |parser|
        parser.on("-d", "--department <DEPARTMENT>", "Specify which department to book rooms from") do |v|
          options[:department] = v
        end
        parser.on("-h", "--help", "Show this help message") do ||
          puts parser
          exit(0)
        end
        parser.on("-l", "--list", "List supported departments") do ||
          @app_config.print_supported_departments
          exit(0)
        end
        parser.on("-s", "--save", "Save username and password") do |v|
          options[:save]
        end
        parser.on("-u", "--update", "Update username and password") do |v|
          ask_config
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
      rescue OptionParser::MissingArgument
        puts "Missing a department option\n".red <<
          "Try calling with `ubcbooker -d <DEPARTMENT>`\n".brown <<
          "Check supported departments with `ubcbooker -l`".brown
        exit(1)
      end
    end

    def start
      options = get_options
      if !@app_config.defined?
        ask_config
      end
      binding.pry
      Ubcbooker::Http.new.login(@app_config.username, @app_config.password)
    end
  end
end
