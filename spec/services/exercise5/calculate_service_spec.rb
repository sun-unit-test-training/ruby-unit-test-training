require "rails_helper"

RSpec.describe Exercise5::CalculateService, type: :service do
  let(:caculate_service) { described_class.new(total_bill, pickup_at_store, have_voucher) }
  let(:total_bill) { 1000 }
  let(:pickup_at_store) { true }
  let(:have_voucher) { true }

  describe "#new" do
    let(:service) { Exercise5::CalculateService }

    context "when pass enought args" do
      it { expect { service.new(1500, true, nil) }.to_not raise_error }
      it { expect { service.new(1500, true, nil).perform }.to_not raise_error }
      it { expect { service.new(1500, nil, true) }.to_not raise_error }
      it { expect { service.new(1500, nil, true).perform }.to_not raise_error }
      it { expect { service.new(nil, true, true) }.to_not raise_error }
      it { expect { service.new(nil, true, true).perform }.to_not raise_error }
      it { expect { service.new(nil, nil, nil) }.to_not raise_error }
      it { expect { service.new(nil, nil, nil).perform }.to_not raise_error }
    end

    context "when miss args" do
      it { expect { service.new(1, true) }.to raise_error }
    end
  end

  describe "#perform" do
    subject { caculate_service.perform }

    context "when total_bill is nil" do
      let(:total_bill) { nil }

      it_behaves_like "Exercise5::CalculateService#perform", true, nil, [], {}
    end

    context "when total_bill is invalid" do
      let(:total_bill) { -1000 }

      it_behaves_like "Exercise5::CalculateService#perform", false, -1000, [], { total_bill: :invalid }
    end

    context "when total_bill is valid" do
      context "when caculate promotion" do
        context "when total_bill is greater than min_bill_for_discount" do
          let(:total_bill) { 1600 }

          it_behaves_like "Exercise5::CalculateService#perform", true, 1600, ["Tặng khoai tây", "Tặng Pizza thứ 2"], {}
        end

        context "when total_bill is equal to min_bill_for_discount" do
          let(:total_bill) { 1500 }

          it_behaves_like "Exercise5::CalculateService#perform", true, 1500, ["Tặng Pizza thứ 2"], {}
        end

        context "when total_bill is less than min_bill_for_discount" do
          let(:total_bill) { 1400 }

          it_behaves_like "Exercise5::CalculateService#perform", true, 1400, ["Tặng Pizza thứ 2"], {}
        end

        context "when pickup_at_store is truthy" do
          let(:pickup_at_store) { true }

          it_behaves_like "Exercise5::CalculateService#perform", true, 1000, ["Tặng Pizza thứ 2"], {}
        end

        context "when pickup_at_store is falsy" do
          let(:pickup_at_store) { false }

          it_behaves_like "Exercise5::CalculateService#perform", true, 800, ["Giảm giá 20%"], {}
        end
      end

      context "when calculate discount at home" do
        context "when pickup_at_store is present" do
          let(:pickup_at_store) { true }

          it_behaves_like "Exercise5::CalculateService#perform", true, 1000, ["Tặng Pizza thứ 2"], {}
        end

        context "when have_voucher is blank" do
          let(:have_voucher) { false }

          it_behaves_like "Exercise5::CalculateService#perform", true, 1000, ["Tặng Pizza thứ 2"], {}
        end

        context "when pickup_at_store not present and have_voucher not blank" do
          let(:pickup_at_store) { false }
          let(:have_voucher) { true}

          it_behaves_like "Exercise5::CalculateService#perform", true, 800, ["Giảm giá 20%"], {}
        end
      end
    end
  end

  describe "#validate_total_bill" do
    subject { caculate_service.send :validate_total_bill, number }

    context "when number is valid" do
      let(:number) { "1000" }

      it { is_expected.to eq 1000 }
      it { expect { subject }.not_to change { caculate_service.send(:errors) } }
      it { expect { subject }.not_to raise_error(ArgumentError) }
    end

    context "when number is invalid" do
      let(:number) { "-1000" }

      it { expect { subject }.to raise_error(ArgumentError) }
      it do
        subject
      rescue
        expect(caculate_service.send(:errors)).to eq({total_bill: :invalid})
      end
    end
  end

  describe "response" do
    subject { caculate_service.send :response, result }

    let(:result) { true }
    let(:total_bill) { 1000 }
    let(:promotion) { [] }
    let(:errors) { {} }

    before do
      allow(caculate_service).to receive_messages(
        total_bill: total_bill,
        promotion: promotion,
        errors: errors
      )
    end

    it do
      expect(subject.success?).to eq result
      expect(subject.total).to eq total_bill
      expect(subject.promotion).to eq promotion
      expect(subject.errors).to eq errors
    end
  end

  describe "calculate_discount_at_home" do
    subject { caculate_service.send :calculate_discount_at_home }

    let(:pickup_at_store) { false }
    let(:have_voucher) { true }

    context "when pickup_at_store is present" do
      let(:pickup_at_store) { true }

      it { expect { subject }.not_to change { caculate_service.send(:total_bill) } }
      it do
        subject
        expect(caculate_service.send(:promotion)).not_to include "Giảm giá 20%"
      end
    end

    context "when have_voucher is blank" do
      let(:have_voucher) { false }

      it { expect { subject }.not_to change { caculate_service.send(:total_bill) } }
      it do
        subject
        expect(caculate_service.send(:promotion)).not_to include "Giảm giá 20%"
      end
    end

    context "when not pickup_at_store and have_voucher" do
      it { expect { subject}.to change { caculate_service.send(:total_bill) }.from(1000).to(800) }
      it do
        subject
        expect(caculate_service.send(:promotion)).to include "Giảm giá 20%"
      end
    end
  end

  describe "calculate_promotion" do
    subject { caculate_service.send :calculate_promotion }

    let(:promotion) { caculate_service.send(:promotion) }

    before { subject }

    context "when total_bill is greater than min_bill_for_discount" do
      let(:total_bill) { 1600 }

      it { expect(promotion).to include "Tặng khoai tây" }
    end

    context "when total_bill is equal to min_bill_for_discount" do
      let(:total_bill) { 1500 }

      it { expect(promotion).not_to include "Tặng khoai tây" }
    end

    context "when total_bill is less than min_bill_for_discount" do
      let(:total_bill) { 1400 }

      it { expect(promotion).not_to include "Tặng khoai tây" }
    end

    context "when pickup_at_store is truthy" do
      let(:pickup_at_store) { true }

      it { expect(promotion).to include "Tặng Pizza thứ 2" }
    end

    context "when pickup_at_store is falsy" do
      let(:pickup_at_store) { false }

      it { expect(promotion).not_to include "Tặng Pizza thứ 2" }
    end
  end
end
