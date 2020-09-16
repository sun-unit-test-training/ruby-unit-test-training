require "rails_helper"

RSpec.describe LuckyDrawModule do
  subject { dummy_controller.lucky_draw }

  let(:dummy_controller) { ApplicationController.new { extend LuckyDrawModule }}

  describe "#lucky_draw" do
    context "when draw lucky" do
      # Assume We have percentage of lucky draw is 20%
      # So we have 10 numbers in draw box: 1, 2,..., 10
      # 20% such as 2 lucky numbers is 1, 2
      # then we mock rand method to return 1 or 2
      before { expect(dummy_controller).to receive(:rand).with(10).and_return(1) }

      it { is_expected.to eq true }
    end

    context "when draw unlucky" do
      # then we mock rand method to return 3
      before { expect(dummy_controller).to receive(:rand).with(10).and_return(3) }

      it { is_expected.to eq false }
    end
  end
end
