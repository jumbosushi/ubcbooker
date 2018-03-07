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

    # TODO: Return error msg explaining this
    def is_valid_date(d)
      date = nil
      begin
        date = Date.parse(d)
        # Expect MM/DD
      rescue ArgumentError
        return false
      end
      return /^\d\d\/\d\d$/.match?(d) &&          # Match format
             date.weekday? &&  # Not on weekend
             !date.past? &&                       # Not in the past
             (date < Date.today + 7)              # Within a week
    end

    def is_valid_time(t)
      if /^\d\d:\d\d-\d\d:\d\d$/.match?(t)
        times = t.split("-")
        times.each do |time|
          begin
            DateTime.parse(time)
            # Expect HH:MM
          rescue ArgumentError
            return false
          end
        end
        return true
      else
        return false
      end
    end

    def parse_options
      # This will hold the options we parse
      options = {
        save: false,
        update: false,
        date: nil,
        time: nil,
        department: nil,
      }

      # TODO: Change department to building
      OptionParser.new do |parser|
        parser.on("-b", "--building [BUILDING]", String,
                  "Specify which department to book rooms from") do |v|
          if is_valid_department(v)
            options[:department] = v
          else
            raise Ubcbooker::Error::UnsupportedDepartment.new(v)
          end
        end

        parser.on("-d", "--date [DATE]", String,
                  "Specify date to book rooms for (MM/DD)") do |v|
          if is_valid_date(v)
            options[:date] = v
          else
            raise Ubcbooker::Error::UnsupportedDate.new(v)
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

        parser.on("-t", "--time [TIME]", String,
                  "Specify time to book rooms for (HH:MM-HH:MM)") do |v|
          if is_valid_time(v)
            options[:time] = v
          else
            raise Ubcbooker::Error::UnsupportedTime.new(v)
          end
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

    def get_department_scraper(department)
      case department
      when "cs"
        return Ubcbooker::Scraper::Cs
      when "sauder_ugrad"
        return Ubcbooker::Scraper::SauderUgrad
      else
        raise Ubcbooker::Error::UnsupportedDepartment
      end
    end

    def get_scraper(department, username, password)
      scraper_client = get_department_scraper(department)
      return scraper_client.new(username, password)
    end

    def start
      @options = get_options
      ask_config if !@config.defined? || @options[:update]
      @client = get_scraper(@options[:department],
                            @config.account["username"],
                            @config.account["password"])
      @client.book(@options)
    end
  end
end
