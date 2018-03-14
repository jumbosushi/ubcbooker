module Ubcbooker
  module Error
    class UnsupportedDepartment < StandardError
      attr_reader :message
      def initialize(department = "unknown")
        @message = "\"#{department}\" is an unsupported department\n".red <<
          "Check supported departments with `ubcbooker -l`"
        super
      end
    end

    class UnsupportedDate < StandardError
      attr_reader :message, :date
      def initialize(date = "unknown")
        @date = date
        @message = "Error: Unsupported Date\n".red <<
          "Date must not be:\n" <<
          "  - in the past\n" <<
          "  - in a weekend\n" <<
          "  - beyond a week\n" <<
          "Please check if the time is in the format of MM/DD\n" <<
          "Ex. 03/05"
        super
      end
    end

    class UnsupportedTime < StandardError
      attr_reader :message, :time
      def initialize(time = "unknown")
        @time = time
        @message = "Error: Unsupported Time\n".red <<
          "Please check if the time is in the format of HH:MM-HH:MM\n" <<
          "Ex. 11:00-13:00"
        super
      end
    end

    class MissingRequired < StandardError
      attr_reader :message, :time
      def initialize()
        @message = "Error: Missing Option\n".red <<
          "One or more of required option are missing values\n" <<
          "Please check if options -b, -d, -n, and -t all have values passed"
        super
      end
    end


    class ProfaneName < StandardError
      attr_reader :message, :name
      def initialize(name = "unknown")
        @name = name
        @message = "Error: Name includes profanity\n".red <<
          "Remember that other students might see the booking name\n" <<
          "Please try again with a different name"
        super
      end
    end

    class NoAvailableRoom < StandardError
      attr_reader :message, :time_range
      def initialize(time_range)
        @time_range = time_range
        @message = "Error: No Available Room\n".red <<
          "There are no room available for #{time_range} range\n" <<
          "Please try again with a different time range"
        super
      end
    end

    class LoginFailed < StandardError
      attr_reader :message
      def initialize
        @message = "\nLogin Failed :/\n".red <<
          "Please try logging in with a different username or password\n" <<
          "You can use `-u` flag to update saved accout info"
        super
      end
    end
  end
end
