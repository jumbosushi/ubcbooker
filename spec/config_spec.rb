RSpec.describe Ubcbooker::Config do
  require "keyring"
  require "rubygems/test_case"

  let(:config) { Ubcbooker::Config.new }
  let(:keyring) { Keyring.new }

  after(:each) do
    config.delete_credentials
  end

  describe "#save_credentials" do
    context "running on osx / linux" do
      it "save params into keyring" do
        config.save_credentials("testuser", "testpass")
        expect(keyring.get_password("ubcbooker", "username")).to eq("testuser")
        expect(keyring.get_password("ubcbooker", "password")).to eq("testpass")
      end
    end

    context "running on windows" do
      it "save params locally" do
        Gem.win_platform = true
        config.save_credentials("testuser", "testpass")
        expect(keyring.get_password("ubcbooker", "username")).to eq(false)
        expect(keyring.get_password("ubcbooker", "password")).to eq(false)
        expect(config.get_username).to eq("testuser")
        expect(config.get_password).to eq("testpass")
        Gem.win_platform = false
      end
    end
  end

  describe "#defined?" do
    context "when #ask has not been called before" do
      it "return false" do
        expect(config.defined?).to equal(false)
      end
    end

    context "when #ask has been called before" do
      it "return true" do
        allow(config).to receive(:gets).and_return("testuser")
        allow(STDIN).to receive(:noecho).and_return("testuser")
        config.ask
        expect(config.defined?).to equal(true)
      end
    end
  end

end
