module Ubcbooker
  class Config
    attr_accessor :account

    def initialize
      @config_path = File.expand_path("../config.yml", __FILE__)
      @account = YAML.load_file(@config_path)
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
      SUPPORTED_DEPARTMENTS.each do |d|
        puts "    -  #{d}"
      end
    end

    def defined?
      return @account["username"] != "hoge" && @account["password"] != "hoge"
    end
  end
end
