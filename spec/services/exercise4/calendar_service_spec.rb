require "rails_helper"

RSpec.describe Exercise4::CalendarService do
  describe "#perform" do
    let(:day_in_month) { "2020-09-22" }

    subject { described_class.new(day_in_month).perform }

    shared_examples 'calendar color' do
      it do
        expect(subject.data).to eq calendar_color
        expect(subject.errors).to be_empty
      end
    end

    context "when return red color" do
      let(:calendar_color) {{ 22=>"red" }}

      context "when day_in_month is sunday" do
        before do
          allow_any_instance_of(described_class).to receive(:sunday?).and_return true
        end
  
        include_examples 'calendar color', :calendar_color
      end
  
      context "when day_in_month is holiday" do
        context "and is sunday" do
          before do
            allow_any_instance_of(described_class).to receive(:holiday?).and_return true
            allow_any_instance_of(described_class).to receive(:sunday?).and_return true
          end
    
          include_examples 'calendar color', :calendar_color
        end
  
        context "and is saturday" do
          before do
            allow_any_instance_of(described_class).to receive(:holiday?).and_return true
            allow_any_instance_of(described_class).to receive(:saturday?).and_return true
          end
    
          include_examples 'calendar color', :calendar_color
        end
  
        context "and is normal day" do
          before do
            allow_any_instance_of(described_class).to receive(:holiday?).and_return true
            allow_any_instance_of(described_class).to receive(:saturday?).and_return false
            allow_any_instance_of(described_class).to receive(:sunday?).and_return false
          end
    
          include_examples 'calendar color', :calendar_color
        end
      end
    end

    context "when day_in_month is saturday" do
      let(:calendar_color) {{ 22=>"blue" }}

      before do
        allow_any_instance_of(described_class).to receive(:saturday?).and_return true
        allow_any_instance_of(described_class).to receive(:holiday?).and_return false
      end

      include_examples 'calendar color', :calendar_color
    end

    context "when day_in_month is normal day" do
      let(:calendar_color) {{ 22=>"black" }}

      before do
        allow_any_instance_of(described_class).to receive(:saturday?).and_return false
        allow_any_instance_of(described_class).to receive(:holiday?).and_return false
        allow_any_instance_of(described_class).to receive(:sunday?).and_return false
      end

      include_examples 'calendar color', :calendar_color
    end

    context "#saturday?" do
      let(:day_in_month) { "2020-09-19" }

      subject {described_class.new(day_in_month).send :saturday?}

      it{is_expected.to eq true}
    end

    context "#response" do
      subject {described_class.new(day_in_month).send :response}

      context "when day_in_month is incorrect format" do
        let(:day_in_month) { "2020-12nnn-22" }

        it do
          expect(subject.success).to eq false
          expect(subject.data).to be_empty
          expect(subject.errors).to eq ({:day_in_month=>:invalid})
        end
      end

      context "when day_in_month is nil" do
        let(:day_in_month) { nil }

        it do
          expect(subject.success).to eq false
          expect(subject.data).to be_empty
          expect(subject.errors).to be_empty
        end
      end
    end
  end
end
