require "rails_helper"

RSpec.describe Exercise4::CalendarService do
  let(:calendar_service) { described_class.new(day_in_month) }
  let(:day_in_month) { "2020-09-22" }

  describe "#perform" do
    subject { calendar_service.perform }

    context "when day_in_month is invalid" do
      context "when day_in_month is invalid format" do
        let(:day_in_month) { "20-09-22" }

        it_behaves_like "Exercise4::CalendarService#perform", false, {}, { day_in_month: :invalid }
      end

      context "when day_in_month is invalid blank" do
        [nil, "", "  "].each do |value|
          let(:day_in_month) { value }

          it_behaves_like "Exercise4::CalendarService#perform", false, {}, {}
        end
      end

      context "when day_in_month is valid" do
        let(:holiday) { false }
        let(:sunday) { false }
        let(:saturday) { false }

        before do
          allow(calendar_service).to receive_messages(
            holiday?: holiday,
            sunday?: sunday,
            saturday?: saturday
          )
        end

        context "when day_in_month is hodiday" do
          let(:holiday) { true }

          it_behaves_like "Exercise4::CalendarService#perform", true, { 22 => "red" }, {}
        end

        context "when day_in_month is sunday" do
          let(:sunday) { true }

          it_behaves_like "Exercise4::CalendarService#perform", true, { 22 => "red" }, {}
        end

        context "when day_in_month is saturday" do
          let(:saturday) { true }

          it_behaves_like "Exercise4::CalendarService#perform", true, { 22 => "blue" }, {}
        end

        context "when day_in_month isn't holiday, sunday or saturday" do
          it_behaves_like "Exercise4::CalendarService#perform", true, { 22 => "black" }, {}
        end
      end
    end
  end

  describe "#calendar_color" do
    subject { calendar_service.send :calendar_color }

    let(:holiday) { false }
    let(:sunday) { false }
    let(:saturday) { false }

    before do
      allow(calendar_service).to receive_messages(
        holiday?: holiday,
        sunday?: sunday,
        saturday?: saturday
      )
    end

    context "when day_in_month is holiday" do
      let(:holiday) { true }

      it { is_expected.to eq({ 22 => "red" }) }
    end

    context "when day_in_month is sunday" do
      let(:sunday) { true }

      it { is_expected.to eq({ 22 => "red" }) }
    end

    context "when day_in_month is saturday" do
      let(:saturday) { true }

      it { is_expected.to eq({ 22 => "blue" }) }
    end

    context "when day_in_month isn't holiday, sunday or saturday" do
      before do
        allow(calendar_service).to receive(:holiday?).and_return(false)
        allow(calendar_service).to receive(:sunday?).and_return(false)
        allow(calendar_service).to receive(:saturday?).and_return(false)
      end

      it { is_expected.to eq({ 22 => "black" }) }
    end
  end

  describe "#param_todate" do
    subject { calendar_service.send :param_todate }

    it { is_expected.to eq day_in_month.to_date }
  end

  %w( red blue black ).each do |value|
    describe "#{value}_color" do
      subject { calendar_service.send "#{value}_color" }

      it { is_expected.to eq ({ 22 => value }) }
    end
  end

  describe "#holiday?" do
    subject { calendar_service.send :holiday? }

    context "when day_in_month is 01-01" do
      let(:day_in_month) { "2020-01-01" }

      it { is_expected.to eq true }
    end

    context "when day_in_month is 30-04" do
      let(:day_in_month) { "2020-04-30" }

      it { is_expected.to eq true }
    end

    context "when day_in_month is 01-05" do
      let(:day_in_month) { "2020-05-01" }

      it { is_expected.to eq true }
    end

    context "when day_in_month is 02-09" do
      let(:day_in_month) { "2020-09-02" }

      it { is_expected.to eq true }
    end

    context "when day_in_month isn't a holiday" do
      let(:day_in_month) { "2020-12-31" }

      it { is_expected.to eq false }
    end
  end

  describe "#sunday?" do
    subject { calendar_service.send :sunday? }

    context "when param_todate is sunday" do
      let(:day_in_month) { "2020-11-29" }

      it { is_expected.to eq true }
    end

    context "when param_todate isn't sunday" do
      let(:day_in_month) { "2020-11-28" }

      it { is_expected.to eq false }
    end
  end

  describe "#saturday?" do
    subject { calendar_service.send :saturday? }

    context "when param_todate is saturday" do
      let(:day_in_month) { "2020-11-28" }

      it { is_expected.to eq true }
    end

    context "when param_todate isn't saturday" do
      let(:day_in_month) { "2020-11-29" }

      it { is_expected.to eq false }
    end
  end

  describe "#validate_day?" do
    subject { calendar_service.send :validate_day? }

    context "when day_in_month is valid" do
      let(:day_in_month) { "2020-11-28" }

      it { is_expected.to eq true }
    end

    context "when day_in_month is invalid" do
      context "when day_in_month is invalid format" do
        let(:day_in_month) { "20-11-28" }

        it do
          expect(subject).to eq false
          expect(calendar_service.instance_variable_get("@errors")).to eq ({day_in_month: :invalid})
        end
      end

      context "when day_in_month is blank" do
        [nil, "", " "].each do |value|
          let(:day_in_month) { value }

          it do
            expect(subject).to eq false
            expect(calendar_service.instance_variable_get("@errors")).to eq ({})
          end
        end
      end
    end
  end
end
