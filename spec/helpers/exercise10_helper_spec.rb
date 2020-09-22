require "rails_helper"

RSpec.describe Exercise10Helper, type: :helper do
  describe "#ranks_select_options" do
    context "when settings have ranks" do
      let(:expected) { [["Silver", "silver"], ["Gold", "gold"], ["Platinum", "platinum"]] }

      it { expect(helper.ranks_select_options).to eq expected }
    end

    context "when settings don't have ranks" do
      before { allow(Settings.exercise10).to receive(:ranks).and_return([]) }

      it { expect(helper.ranks_select_options).to eq [] }
    end
  end
end
