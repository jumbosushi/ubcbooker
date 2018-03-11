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
        @message = "Error: UnsupportedDate\n".red <<
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
        @message = "Error: UnsupportedTime\n".red <<
          "Please check if the time is in the format of HH:MM-HH:MM\n" <<
          "Ex. 11:00-13:00"
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

    class InvalidRoom < StandardError
    end

    class LoginFailed < StandardError
    end
  end
end
