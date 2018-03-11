module Ubcbooker
  module Error
    class UnsupportedDepartment < StandardError
      attr_reader :message
      def initialize(department = "unknown")
        @message = "\"#{department}\" is an unsupported department\n".red <<
          "Check supported departments with `ubcbooker -l`".brown
        super
      end
    end

    class UnsupportedDate < StandardError
      attr_reader :message, :date
      def initialize(date = "unknown")
        @date = date
        @message = "Error: UnsupportedDate\n".red <<
          "Date must not be:\n".brown <<
          "  - in the past\n".brown <<
          "  - in a weekend\n".brown <<
          "  - beyond a week\n".brown <<
          "Please check if the time is in the format of MM/DD\n".brown <<
          "Ex. 03/05".brown
        super
      end
    end

    class UnsupportedTime < StandardError
      attr_reader :message, :time
      def initialize(time = "unknown")
        @time = time
        @message = "Error: UnsupportedTime\n".red <<
          "Please check if the time is in the format of HH:MM-HH:MM\n".brown <<
          "Ex. 11:00-13:00".brown
        super
      end
    end

    class ProfaneName < StandardError
      attr_reader :message, :name
      def initialize(name = "unknown")
        @name = name
        @message = "Error: Name includes profanity\n".red <<
          "Remember that other students might see the booking name\n".brown <<
          "Please try again with a different name".brown
        super
      end
    end

    class InvalidRoom < StandardError
    end

    class LoginFailed < StandardError
    end
  end
end
