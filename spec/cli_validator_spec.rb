RSpec.describe Ubcbooker::CLI::Validator do

  let(:validator) { Ubcbooker::CLI::Validator }

  describe "#is_valid_department" do
    context "when input is valid department" do
      it "returns true" do
        expect(validator.is_valid_department("cs")).to eq(true)
      end
    end

    context "when input is invalid department" do
      it "returns false" do
        expect(validator.is_valid_department("eng")).to eq(false)
      end
    end
  end

  describe "#is_valid_date" do
    context "when input is valid date" do
      it "returns true" do
        valid_date = Date.today.strftime("%m/%d")
        expect(validator.is_valid_date(valid_date)).to eq(true)
      end
    end

    context "when input is invalid date format" do
      it "return false" do
        expect(validator.is_valid_date("fail")).to eq(false)
      end
    end

    context "when input date is in the past" do
      it "returns false" do
        past_date = (Date.today - 10).strftime("%m/%d")
        expect(validator.is_valid_date(past_date)).to eq(false)
      end
    end

    context "when input date is beyond a week" do
      it "returns false" do
        future_date = (Date.today + 10).strftime("%m/%d")
        expect(validator.is_valid_date(future_date)).to eq(false)
      end
    end
  end

  describe "#is_valid_time" do
    context "when input date is valid time format" do
      it "returns true" do
        valid_time = "10:00-11:00"
        expect(validator.is_valid_time(valid_time)).to eq(true)
      end
    end

    context "when input date is invalid time format" do
      it "returns false" do
        invalid_time1 = "10:00_11:00"
        expect(validator.is_valid_time(invalid_time1)).to eq(false)

        invalid_time2 = "99:99-99:99"
        expect(validator.is_valid_time(invalid_time2)).to eq(false)
      end
    end
  end

  describe "#is_required_missing" do
    context "when required fields are not nil in option" do
      it "returns false" do
        option = {
          name: "test",
          date: "03/12",
          time: "10:00-11:00",
          department: "cs",
        }
        expect(validator.is_required_missing(option)).to eq(false)
      end
    end

    context "when one or more of required fields are nil in option" do
      it "returns true" do
        option = {
          name: "test",
          date: nil,
          time: "10:00-11:00",
          department: "cs",
        }
        expect(validator.is_required_missing(option)).to eq(true)
      end
    end
  end

  describe "#is_valid_name" do
    context "when input does not contain profanity key words" do
      it "returns true" do
        valid_name = "Group Work"
        expect(validator.is_valid_name(valid_name)).to eq(true)
      end
    end

    context "when input contain profanity key words" do
      it "returns false" do
        invalid_name = "Shit Group Work"
        expect(validator.is_valid_name(invalid_name)).to eq(false)
        invalid_name2 = "Fucking study group"
        expect(validator.is_valid_name(invalid_name2)).to eq(false)
      end
    end
  end

end
