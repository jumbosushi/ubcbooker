module Ubcbooker
  class CLI
    module Validator
      def self.is_valid_department(d)
        return BOOKING_URL.keys.include?(d.to_sym)
      end

      def self.is_valid_date(d)
        date = nil
        begin
          date = Date.parse(d)
          # Expect MM/DD
        rescue ArgumentError
          return false
        end
        return /^\d\d\/\d\d$/.match?(d) &&   # Match format
               date.weekday? &&              # Not on weekend
               !date.past? &&                # Not in the past
               (date < Date.today + 7)       # Within a week
      end

      def self.is_valid_time(t)
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

      def self.is_required_missing(options)
        return options[:name].nil? || options[:date].nil? ||
               options[:time].nil? || options[:department].nil?
      end

      # False if the name contains any profanity
      def self.is_valid_name(name)
        return !Obscenity.profane?(name)
      end
    end
  end
end
