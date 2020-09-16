require "rails_helper"

RSpec.describe Exercise10::CalculateTotalAmountService do
  describe "#perform" do
    context "when perform success" do
      subject { described_class.new(rank, total_amount).perform }

      shared_examples "do not discount" do |total_amount|
        let(:total_amount) { total_amount }

        it { expect(subject).to eq total_amount }
      end

      shared_examples "out ranger discount" do
        it_behaves_like "do not discount", 2999
        it_behaves_like "do not discount", 3001
        it_behaves_like "do not discount", 4999
        it_behaves_like "do not discount", 5001
        it_behaves_like "do not discount", 9999
        it_behaves_like "do not discount", 10001
      end

      context "when rank is `SILVER`" do
        let(:rank) { Settings.excercise10.rank.silver }

        context "when total amount is 3000円" do
          let(:total_amount) { 3000 }

          it "return amount discount 1%" do
            expect(subject).to eq 2970.0
          end
        end

        context "when total amount is 5000円" do
          let(:total_amount) { 5000 }

          it "return amount discount 2%" do
            expect(subject).to eq 4900.0
          end
        end

        context "when total amount is 10000円" do
          let(:total_amount) { 10000 }

          it "return amount discount 4%" do
            expect(subject).to eq 9600.0
          end
        end

        include_examples "out ranger discount"
      end

      context "when rank is `GOLD`" do
        let(:rank) { Settings.excercise10.rank.gold }

        context "when total amount is 3000円" do
          let(:total_amount) { 3000 }

          it "return amount discount 3%" do
            expect(subject).to eq 2910.0
          end
        end

        context "when total amount is 5000円" do
          let(:total_amount) { 5000 }

          it "return amount discount 5%" do
            expect(subject).to eq 4750.0
          end
        end

        context "when total amount is 10000円" do
          let(:total_amount) { 10000 }

          it "return amount discount 10%" do
            expect(subject).to eq 9000.0
          end
        end

        include_examples "out ranger discount"
      end

      context "when rank is `PLATINUM`" do
        let(:rank) { Settings.excercise10.rank.platinum }

        context "when total amount is 3000円" do
          let(:total_amount) { 3000 }

          it "return amount discount 5%" do
            expect(subject).to eq 2850.0
          end
        end

        context "when total amount is 5000円" do
          let(:total_amount) { 5000 }

          it "return amount discount 7%" do
            expect(subject).to eq 4650.0
          end
        end

        context "when total amount is 10000円" do
          let(:total_amount) { 10000 }

          it "return amount discount 15%" do
            expect(subject).to eq 8500.0
          end
        end

        include_examples "out ranger discount"
      end

      context "when rank is another" do
        let(:rank) { 0 }

        it_behaves_like "do not discount", 3000
        it_behaves_like "do not discount", 5000
        it_behaves_like "do not discount", 10000
      end
    end

    context "when something failed" do
      context "when total_amount is invalid" do
        it do
          expect{ subject }.to raise_error
        end
      end
    end
  end
end
