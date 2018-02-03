module Ubcbooker
  class Account
    attr_accessor :username, :password

    def initialize
      @config_path = File.expand_path("../config.yml", __FILE__)
      @account_info = YAML.load_file(@config_path)
      @username = @account_info["username"]
      @password = @account_info["password"]
    end

    def write(username, password)
      @account["username"] = username
      @account["password"] = password
      new_yml = YAML.dump(@account)
      open(@config_path, "w") { |f| f.write(new_yml) }
      @account = YAML.load_file(@config_path)
    end

    def print_supported_departments
      puts "Supported department options in #{Ubcbooker::VERSION}:"
      BOOKING_URL.keys.each do |d|
        puts "    -  #{d}"
      end
    end

    def defined?
      return @account["username"] != "hoge" && @account["password"] != "hoge"
    end
  end
end
