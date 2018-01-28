module Ubcbooker
  class Config
    attr_accessor :account

    def initialize
      @config_path = File.dirname(File.expand_path(__FILE__)) + "/config.yml"
      @account = YAML.load_file(@config_path)
    end

    def write(username, password)
      @account["username"] = username
      @account["password"] = password
      new_yml = YAML.dump(@account)
      open(@config_path, "w") { |f| f.write(new_yml) }
      @account = YAML.load_file("./config.yaml")
    end

    def defined?
      return @account["username"] != "hoge" && @account["password"] != "hoge"
    end
  end
end
