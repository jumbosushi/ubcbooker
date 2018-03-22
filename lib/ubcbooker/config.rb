module Ubcbooker
  class Config
    attr_accessor :account

    # We use system keyring for storing cwl credentials
    # https://askubuntu.com/questions/32164/what-does-a-keyring-do
    #
    # since the keyring gem doesn't suppot Windows, we ask for cred each time
    # if the user is on OSX or Linux, username and password will be stored in keyring
    def initialize
      @keyring = Keyring.new
      @win_username = ""
      @win_password = ""
    end

    def ask
      print "Your CWL username: "
      username = gets.chomp
      print "Your CWL password: "
      # Hide the password input
      password = STDIN.noecho(&:gets).chomp
      save_credentials(username, password)
      puts
    end

    def save_credentials(username, password)
      if is_windows?
        @win_username = username
        @win_pasword = password
      else
        @keyring.set_password("ubcbooker", "username", username)
        @keyring.set_password("ubcbooker", "password", password)
      end
    end

    def print_supported_departments
      puts "Supported department options in #{Ubcbooker::VERSION}:"
      BOOKING_URL.keys.each do |d|
        puts "    -  #{d}"
      end
    end

    # True if user is on windows platform
    def is_windows?
      return Gem.win_platform?
    end

    # Delete stored user credentials
    # Used in specs
    def delete_credentials
      if is_windows?
        @win_username = ""
        @win_password = ""
      else
        @keyring.delete_password("ubcbooker", "username")
        @keyring.delete_password("ubcbooker", "password")
      end
    end

    def get_username
      if is_windows?
        return @win_username
      else
        return @keyring.get_password("ubcbooker", "username")
      end
    end

    def get_password
      if is_windows?
        return @win_pasword
      else
        return @keyring.get_password("ubcbooker", "password")
      end
    end

    def defined?
      return !!(get_username && get_password)
    end
  end
end
