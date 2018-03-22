RSpec.describe Ubcbooker::CLI do

  # Disable warning msg for overwritting ARGV
  before(:all) do
    $VERBOSE = nil
  end

  # Enable warning msg for overwritting ARGV
  after(:all) do
    $VERBOSE = false
  end

  let(:cli) { Ubcbooker::CLI.new }
  let(:tmrw_date) { (Date.today + 1).strftime("%m/%d") }

  describe "#get_department_scraper" do
    context "when param is cs" do
      it "return CS Scrapper class" do
        result = cli.get_department_scraper("cs")
        expect(result).to eq(Ubcbooker::Scraper::Cs)
      end
    end

    context "when param is unknown department" do
      it "raise UnsupportedDepartment error" do
        expect do
          cli.get_department_scraper("boozilogy")
        end.to raise_error(Ubcbooker::Error::UnsupportedDepartment)
      end
    end
  end

  describe "#parse_options" do
    context "when ARGV is valid" do
      it "returns valid options" do
        ARGV = ["-b", "cs",
                "-n", "test_name",
                "-d", tmrw_date,
                "-t", "15:30-17:00"]
        expected_options = {
          name: "test_name",
          date: tmrw_date,
          time: "15:30-17:00",
          department: "cs",
        }
        result = cli.parse_options
        expect(result).to eq(expected_options)
      end
    end

    context "when required options are missing" do
      it "raise Ubcbooker::Error::MissingRequired" do
        # Missing -n flag
        ARGV = ["-b", "cs",
                "-d", tmrw_date,
                "-t", "15:30-17:00"]
        expect do
          cli.parse_options
        end.to raise_error(Ubcbooker::Error::MissingRequired)
      end
    end

    context "when -b is unsupported department" do
      it "raise Ubcbooker::Error::UnsupportedDepartment" do
        # Missing -n flag
        ARGV = ["-b", "booziogy",
                "-n", "test_name",
                "-d", tmrw_date,
                "-t", "15:30-17:00"]
        expect do
          cli.parse_options
        end.to raise_error(Ubcbooker::Error::UnsupportedDepartment)
      end
    end

    context "when -n contains profanity" do
      it "raise Ubcbooker::Error::ProfaneName" do
        # Missing -n flag
        ARGV = ["-b", "cs",
                "-n", "fucking group work",
                "-d", tmrw_date,
                "-t", "15:30-17:00"]
        expect do
          cli.parse_options
        end.to raise_error(Ubcbooker::Error::ProfaneName)
      end
    end

    context "when -d is unsupported date" do
      it "raise Ubcbooker::Error::UnsupportedDate" do
        # Missing -n flag
        ARGV = ["-b", "cs",
                "-n", "test_name",
                "-d", "99/99",
                "-t", "15:30-17:00"]
        expect do
          cli.parse_options
        end.to raise_error(Ubcbooker::Error::UnsupportedDate)
      end
    end

    context "when -u" do
      it "call Ubcbooker::Config#ask" do
        # Missing -n flag
        ARGV = ["-u"]
        cli_config = cli.instance_variable_get(:@config)
        expect(cli_config).to receive(:ask)
        cli.parse_options
      end
    end

    context "when -v" do
      it "prints version" do
        # Missing -n flag
        ARGV = ["-v"]
        expect { cli.parse_options }.to output(Ubcbooker::VERSION).to_stdout
      end
    end
  end

  describe "#get_department_scraper" do
    context "when param is cs" do
      it "return CS Scrapper class" do
        result = cli.get_department_scraper("cs")
        expect(result).to eq(Ubcbooker::Scraper::Cs)
      end
    end
  end
end
