module Ubcbooker
  module Error
    class UnsupportedDepartment < StandardError
      attr_reader :department
      def initialize(department="unknown")
        @department = department
        super
      end
    end
  end
end
