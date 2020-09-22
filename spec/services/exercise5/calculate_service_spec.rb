require 'rails_helper'

RSpec.describe Exercise5::CalculateService, type: :service do
  shared_examples "response examples" do |total, promotion|
    it { expect(subject.total).to eq total }
    it { expect(subject.promotion).to eq promotion }
  end

  shared_examples "response when args's invalid" do |total, promotion|
    it { is_expected.to eq :invalid }
  end

  describe '#new' do
    let(:service) { Exercise5::CalculateService }

    context 'when pass enought args' do
      it { expect { service.new(1500, true, nil) }.to_not raise_error }
      it { expect { service.new(1500, true, nil).perform }.to_not raise_error }
      it { expect { service.new(1500, nil, true) }.to_not raise_error }
      it { expect { service.new(1500, nil, true).perform }.to_not raise_error }
      it { expect { service.new(nil, true, true) }.to_not raise_error }
      it { expect { service.new(nil, true, true).perform }.to_not raise_error }
      it { expect { service.new(nil, nil, nil) }.to_not raise_error }
      it { expect { service.new(nil, nil, nil).perform }.to_not raise_error }
    end

    context 'when miss args' do
      it { expect { service.new(1, true) }.to raise_error }
    end
  end

  describe '#perform' do
    let(:service) { Exercise5::CalculateService.new(*args) }
    let(:response) { service.perform }

    describe 'validate args' do
      context 'when total_bill is invalid' do
        subject { response.errors[:total_bill] }

        context 'when total_bill is negative' do
          let(:args) { [-2, nil, nil] }

          include_examples "response when args's invalid"
        end

        context 'when total_bill is not number' do
          context 'when total_bill is character' do
            let(:args) { ['abc', nil, nil] }

            include_examples "response when args's invalid"
          end

          context 'when total_bill is float' do
            let(:args) { [1.5, nil, nil] }

            include_examples "response when args's invalid"
          end
        end
      end
    end

    describe 'calculate logic' do
      subject { service.perform }

      context 'when bill over 1500yen' do
        context 'deliver to home' do
          context 'with coupon' do
            let(:args) { [1501, nil, true] }

            include_examples "response examples", 1201, ["Tặng khoai tây", "Giảm giá 20%"]
          end

          context 'without coupon' do
            let(:args) { [1501, nil, nil] }

            include_examples "response examples", 1501, ["Tặng khoai tây"]
          end
        end

        context 'pickup at store' do
          context 'with coupon' do
            let(:args) { [1501, true, true] }

            include_examples "response examples", 1501, ["Tặng khoai tây", "Tặng Pizza thứ 2"]
          end

          context 'without coupon' do
            let(:args) { [1501, true, nil] }

            include_examples "response examples", 1501, ["Tặng khoai tây", "Tặng Pizza thứ 2"]
          end
        end
      end

      context 'when bill equal 1500yen' do
        context 'deliver to home' do
          context 'with coupon' do
            let(:args) { [1500, nil, true] }

            include_examples "response examples", 1200, ["Giảm giá 20%"]
          end

          context 'without coupon' do
            let(:args) { [1500, nil, nil] }

            include_examples "response examples", 1500, []
          end
        end

        context 'pickup at store' do
          context 'with coupon' do
            let(:args) { [1500, true, true] }

            include_examples "response examples", 1500, ["Tặng Pizza thứ 2"]
          end

          context 'without coupon' do
            let(:args) { [1500, true, nil] }

            include_examples "response examples", 1500, ["Tặng Pizza thứ 2"]
          end
        end
      end

      context 'when bill under 1500yen' do
        context 'deliver to home' do
          context 'with coupon' do
            let(:args) { [1499, nil, true] }

            include_examples "response examples", 1200, ["Giảm giá 20%"]
          end

          context 'without coupon' do
            let(:args) { [1499, nil, nil] }

            include_examples "response examples", 1499, []
          end
        end

        context 'pickup at store' do
          context 'with coupon' do
            let(:args) { [1499, true, true] }

            include_examples "response examples", 1499, ["Tặng Pizza thứ 2"]
          end

          context 'without coupon' do
            let(:args) { [1499, true, nil] }

            include_examples "response examples", 1499, ["Tặng Pizza thứ 2"]
          end
        end
      end

      context 'when bill is nil' do
        let(:args) { [nil, nil, nil] }

        include_examples "response examples", nil, []
      end
    end
  end
end
