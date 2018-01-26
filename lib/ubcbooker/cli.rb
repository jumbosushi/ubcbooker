module Ubcbooker
  class CLI
    attr_accessor :username, :password

    # What happens if I'm already logged in here?
    # Maybe check by seeing if the CWL link pops up after GET
    def initialize
      print "CWL username: "
      self.username = gets.chomp
      print "CWL password: "
      # Hide the password input
      self.password = STDIN.noecho(&:gets).chomp
      puts
    end

    def start
      Ubcbooker::Http.new.login(self)
    end
  end
end
