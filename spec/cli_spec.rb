RSpec.describe Ubcbooker::CLI do

  subject(:cli) { Ubcbooker::CLI.new }

  describe "#ask_config" do
    it "use user input as username & password" do
      allow(cli).to receive(:gets).and_return("testuser")
      allow(STDIN).to receive(:noecho).and_return("testuser")
      cli.ask_config
      expect(Ubcbooker::Config.new.defined?).to equal(true)
    end
  end
end
