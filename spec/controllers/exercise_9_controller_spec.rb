require "rails_helper"

RSpec.describe Exercise9Controller do
  describe "#index" do
    subject { get :index, params: params }

    let(:magic_wand) { "1" }
    let(:companion_mage) { "2" }
    let(:dark_key) { "3" }
    let(:light_sword) { "4" }
    let(:params) do
      {
        magic_wand: magic_wand,
        companion_mage: companion_mage,
        dark_key: dark_key,
        light_sword: light_sword
      }
    end
    let(:key_result) { "1234" }
    let(:hanoi_quest) { double result: result }
    let(:result) { "result" }

    before do
      allow(HanoiQuest).to receive(:find_by).with(key_result: key_result).and_return(hanoi_quest)
    end

    it "should find HanoiQuest by key_result with key_result" do
      expect(HanoiQuest).to receive(:find_by).with(key_result: key_result)
      subject
    end

    context "when hanoi_quest is not not found" do
      let(:hanoi_quest) { nil }

      it "should assigns result with nil" do
        subject
        expect(assigns(:result)).to eq nil
      end
    end

    context "when hanoi_quest is found" do
      it "should assigns result with result" do
        subject
        expect(assigns(:result)).to eq result
      end
    end
  end
end
