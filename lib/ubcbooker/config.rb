module Ubcbooker
  class Config
    attr_accessor :account

    def initialize
      @config_path = get_config_path
      if !File.exist?(@config_path)
        create_config_file(@config_path)
      end

      @account = YAML.load_file(@config_path)
    end

    def ask
      print "Your CWL username: "
      username = gets.chomp
      print "Your CWL password: "
      # Hide the password input
      password = STDIN.noecho(&:gets).chomp
      write(username, password)
      puts
    end

    def create_config_file(config_path)
      File.open(config_path, "w") do |f|
        f.write("---\nusername: sample\npassword: sample")
      end
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

    def get_config_path
      if ENV['RACK_ENV'] == 'test'
        File.expand_path("../config.yml", __FILE__)
      else
        File.expand_path("../../../spec/config.yml", __FILE__)
      end
    end

    def defined?
      return File.exist?(@config_path) &&
             @account["username"] != "sample" &&
             @account["password"] != "sample"
    end
  end
end
