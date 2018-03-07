module Ubcbooker
  module Error
    class UnsupportedDepartment < StandardError
      attr_reader :department
      def initialize(department = "unknown")
        @department = department
        super
      end
    end

    class UnsupportedDate < StandardError
      attr_reader :date
      def initialize(date = "unknown")
        @date = date
        super
      end
    end

    class UnsupportedTime < StandardError
      attr_reader :time
      def initialize(time = "unknown")
        @time = time
        super
      end
    end

    class InvalidRoom < StandardError
    end

    class LoginFailed < StandardError
    end
  end
end
