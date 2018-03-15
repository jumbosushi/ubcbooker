RSpec.describe Ubcbooker::Scraper::Cs do

  let(:scraper) { Ubcbooker::Scraper::Cs.new("testuser", "testpass") }

  describe "#get_time_slot" do
    it "returns a timeslot as range of time str" do
      expected_output = ("13:00".."14:00")
      expect(scraper.get_time_slot("13:00-14:00")).to eq(expected_output)
    end
  end

  describe "#ampm_to_time" do
    it "returns a timeslot as range of time str" do
      expected_output = "14:00"
      expect(scraper.ampm_to_time("02:00pm")).to eq(expected_output)
    end
  end

  describe "#time_to_ampm" do
    it "returns a timeslot as range of time str" do
      expected_output = "02:00pm"
      expect(scraper.time_to_ampm("14:00")).to eq(expected_output)
    end
  end
end
