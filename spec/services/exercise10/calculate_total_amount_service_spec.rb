require "rails_helper"

RSpec.describe Exercise10::CalculateTotalAmountService do
  describe "#perform" do
    let(:service) { described_class.new(rank, total_amount) }

    before do
      service.perform
    end

    shared_examples "do not discount" do |total_amount|
      let(:total_amount) { total_amount }

      it do
        expect(service.total_amount).to eq total_amount
        expect(service.discount_percent).to eq 0
        expect(service.discount_amount).to eq 0
      end
    end

    shared_examples "out ranger discount" do
      it_behaves_like "do not discount", 2999
      it_behaves_like "do not discount", 3001
      it_behaves_like "do not discount", 4999
      it_behaves_like "do not discount", 5001
      it_behaves_like "do not discount", 9999
      it_behaves_like "do not discount", 10001
    end

    context "when perform success" do
      context "when rank is `SILVER`" do
        let(:rank) { 1 }

        context "when total amount is 3000円" do
          let(:total_amount) { 3000 }

          it "return amount discount 1%" do
            expect(service.total_amount).to eq 2970.0
            expect(service.discount_percent).to eq 1
            expect(service.discount_amount).to eq 30.0
          end
        end

        context "when total amount is 5000円" do
          let(:total_amount) { 5000 }

          it "return amount discount 2%" do
            expect(service.total_amount).to eq 4900.0
            expect(service.discount_percent).to eq 2
            expect(service.discount_amount).to eq 100.0
          end
        end

        context "when total amount is 10000円" do
          let(:total_amount) { 10000 }

          it "return amount discount 4%" do
            expect(service.total_amount).to eq 9600.0
            expect(service.discount_percent).to eq 4
            expect(service.discount_amount).to eq 400.0
          end
        end

        include_examples "out ranger discount"
      end

      context "when rank is `GOLD`" do
        let(:rank) { 2 }

        context "when total amount is 3000円" do
          let(:total_amount) { 3000 }

          it "return amount discount 3%" do
            expect(service.total_amount).to eq 2910.0
            expect(service.discount_percent).to eq 3
            expect(service.discount_amount).to eq 90.0
          end
        end

        context "when total amount is 5000円" do
          let(:total_amount) { 5000 }

          it "return amount discount 5%" do
            expect(service.total_amount).to eq 4750.0
            expect(service.discount_percent).to eq 5
            expect(service.discount_amount).to eq 250.0
          end
        end

        context "when total amount is 10000円" do
          let(:total_amount) { 10000 }

          it "return amount discount 10%" do
            expect(service.total_amount).to eq 9000.0
            expect(service.discount_percent).to eq 10
            expect(service.discount_amount).to eq 1000.0
          end
        end

        include_examples "out ranger discount"
      end

      context "when rank is `PLATINUM`" do
        let(:rank) { 3 }

        context "when total amount is 3000円" do
          let(:total_amount) { 3000 }

          it "return amount discount 5%" do
            expect(service.total_amount).to eq 2850.0
            expect(service.discount_percent).to eq 5
            expect(service.discount_amount).to eq 150.0
          end
        end

        context "when total amount is 5000円" do
          let(:total_amount) { 5000 }

          it "return amount discount 7%" do
            expect(service.total_amount).to eq 4650.0
            expect(service.discount_percent).to eq 7
            expect(service.discount_amount).to eq 350.0
          end
        end

        context "when total amount is 10000円" do
          let(:total_amount) { 10000 }

          it "return amount discount 15%" do
            expect(service.total_amount).to eq 8500.0
            expect(service.discount_percent).to eq 15
            expect(service.discount_amount).to eq 1500.0
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
      let(:rank) { 0 }

      context "when total_amount is invalid" do
        context "when total_amount contains character" do
          let(:total_amount) { "123ada" }

          it { expect(service.errors[:total_amount]).to eq :invalid }
        end

        context "when total_amount is a negative" do
          let(:total_amount) { -1 }

          it { expect(service.errors[:total_amount]).to eq :invalid }
        end
      end
    end
  end
end
