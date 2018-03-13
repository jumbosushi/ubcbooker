RSpec.describe Ubcbooker::Config do

  let(:config) { Ubcbooker::Config.new }
  let(:config_path) { config.get_config_path }

  describe "#initialize" do
    context "when there's no config file" do
      it "creates a new config file" do
        if File.exist?(config_path)
          FileUtils.rm(config_path)
        end

        expect(File.exist?(config_path)).to be(false)
        temp_config = Ubcbooker::Config.new
        expect(File.exist?(config_path)).to be(true)
      end
    end
  end

  describe "#write" do
    it "write params into config file" do
      config.write("testuser", "testpass")
      test_config = YAML.load_file(config_path)
      expect(test_config["username"]).to eq("testuser")
      expect(test_config["password"]).to eq("testpass")
    end
  end


  describe "#defined?" do
    context "when there's no config file" do
      it "return false" do
        if File.exist?(config_path)
          FileUtils.rm(config_path)
        end

        expect(config.defined?).to equal(false)
      end
    end

    context "when there's config file" do
      context "when there's default values" do
        it "return false" do
          allow(config).to receive(:gets).and_return("sample")
          allow(STDIN).to receive(:noecho).and_return("sample")
          config.ask
          expect(config.defined?).to equal(false)
        end
      end

      context "when custom values" do
        it "return true" do
          allow(config).to receive(:gets).and_return("testuser")
          allow(STDIN).to receive(:noecho).and_return("testuser")
          config.ask
          expect(config.defined?).to equal(true)
        end
      end
    end
  end

end
