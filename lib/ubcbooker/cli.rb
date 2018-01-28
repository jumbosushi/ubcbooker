module Ubcbooker
  class CLI
    attr_accessor :username, :password

    # What happens if I'm already logged in here?
    # Maybe check by seeing if the CWL link pops up after GET
    def initialize
      if !Ubcbooker::Config.new.defined?
        ask_config
      end
    end

    def ask_config
      print "CWL username: "
      @username = gets.chomp
      print "CWL password: "
      # Hide the password input
      @password = STDIN.noecho(&:gets).chomp
      puts
    end

    def start
      Ubcbooker::Http.new.login(@username, @password)
    end
  end
end
