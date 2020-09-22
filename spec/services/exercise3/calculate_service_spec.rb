require 'rails_helper'

RSpec.describe Exercise3::CalculateService, type: :service do
  let(:params) {
    {
      white_shirt_amount: white_shirt_amount,
      tie_amount: tie_amount,
      other: {
        hat_amount: hat_amount
      }
    }
  }
  describe '#new' do
    let(:service) { Exercise3::CalculateService }
    context 'when pass enought args' do
      let(:white_shirt_amount) { 2 }
      let(:tie_amount) { '' }
      let(:hat_amount) { '1' }
      it { expect { service.new(params) }.to_not raise_error }
      it { expect { service.new(params).perform }.to_not raise_error }
    end

    context 'when not pass args' do
      it { expect { service.new() }.to_not raise_error }
      it { expect { service.new().perform }.to_not raise_error }
    end

    context 'when args invalid' do
      it { expect { service.new('') }.to raise_error }
    end
  end

  describe '#perform' do
    let(:service) { Exercise3::CalculateService.new(params) }
    let(:data) { service.perform }

    shared_examples 'input data invalid' do |field|
      it { expect(data[:errors][field]).to eq :invalid }
    end

    shared_examples 'expect instance value of service' do
      it do
        expect(service.instance_values['white_shirt_amount']).to eq params[:white_shirt_amount]
        expect(service.instance_values['tie_amount']).to eq params[:tie_amount]
        expect(service.instance_values['hat_amount']).to eq params[:hat_amount]
      end
    end

    shared_examples 'Ex3 applied discount' do |expect_data|
      it do
        total_price = expect_data[0]
        discount_price = expect_data[1]
        discount_percent = expect_data[2]
        expect(data[:total_price]).to eq total_price
        expect(data[:discount_price]).to eq discount_price
        expect(data[:discount_percent]).to eq discount_percent
      end
    end

    shared_examples 'Ex3 not applied discount' do |total_price|
      it_behaves_like 'Ex3 applied discount', [total_price, 0, 0]
    end

    describe 'validate params' do
      context 'when white-shirt amount is invalid' do
        context 'is negative' do
          let(:white_shirt_amount) { -1 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 0 }
          it_behaves_like 'input data invalid', :white_shirt_amount
        end

        context 'is not number' do
          let(:white_shirt_amount) { 'abc' }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 0 }
          it_behaves_like 'input data invalid', :white_shirt_amount
        end
      end

      context 'when tie amount is invalid' do
        context 'is negative' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { -1 }
          let(:hat_amount) { 0 }
          it_behaves_like 'input data invalid', :tie_amount
        end

        context 'is not number' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { '123abc' }
          let(:hat_amount) { 0 }
          it_behaves_like 'input data invalid', :tie_amount
        end
      end

      context 'when hat amount is invalid' do
        context 'is negative' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { -1 }
          it_behaves_like 'input data invalid', :hat_amount
        end

        context 'is not number' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 'abc' }
          it_behaves_like 'input data invalid', :hat_amount
        end
      end

      context 'when all input invalid' do
        context 'is negative' do
          let(:white_shirt_amount) { -1 }
          let(:tie_amount) { -1 }
          let(:hat_amount) { -1 }
          it_behaves_like 'input data invalid', :white_shirt_amount
          it_behaves_like 'input data invalid', :tie_amount
          it_behaves_like 'input data invalid', :hat_amount
        end

        context 'is not number' do
          let(:white_shirt_amount) { 'abc' }
          let(:tie_amount) { 'abc' }
          let(:hat_amount) { 'abc' }
          it_behaves_like 'input data invalid', :white_shirt_amount
          it_behaves_like 'input data invalid', :tie_amount
          it_behaves_like 'input data invalid', :hat_amount
        end
      end
    end

    describe 'calculate logic' do
      context 'buy white-shirts and tie' do
        context 'with total amount = 7' do
          let(:white_shirt_amount) { 3 }
          let(:tie_amount) { 4 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 12 %
          it_behaves_like 'Ex3 applied discount', [774_400.0, 105_600.0, 12]
        end

        context 'with total amount > 7' do
          let(:white_shirt_amount) { 4 }
          let(:tie_amount) { 4 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 12 %
          it_behaves_like 'Ex3 applied discount', [950_400.0, 129_600.0, 12]
        end

        context 'with total amount < 7' do
          let(:white_shirt_amount) { 3 }
          let(:tie_amount) { 2 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 5 %
          it_behaves_like 'Ex3 applied discount', [703_000.0, 37_000.0, 5]
        end
      end

      context 'buy white-shirts and other_product' do
        context 'with total amount = 7' do
          let(:white_shirt_amount) { 3 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 4 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [595_200.0, 44_800.0, 7]
        end

        context 'with total amount > 7' do
          let(:white_shirt_amount) { 3 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 5 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [604_500.0, 45_500.0, 7]
        end

        context 'with total amount < 7' do
          let(:white_shirt_amount) { 3 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 2 }
          it_behaves_like 'expect instance value of service'
          # discount 0 %
          it_behaves_like 'Ex3 not applied discount', 620_000
        end
      end

      context 'buy tie and other_product' do
        context 'with total amount = 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 3 }
          let(:hat_amount) { 4 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [232_500.0, 17_500.0, 7]
        end

        context 'with total amount > 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 4 }
          let(:hat_amount) { 4 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [297_600.0, 22_400.0, 7]
        end

        context 'with total amount < 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 2 }
          let(:hat_amount) { 1 }
          it_behaves_like 'expect instance value of service'
          # discount 0 %
          it_behaves_like 'Ex3 not applied discount', 150_000
        end
      end

      context 'buy only white-shirts' do
        context 'with total amount = 7' do
          let(:white_shirt_amount) { 7 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [1_302_000.0, 98_000.0, 7]
        end

        context 'with total amount > 7' do
          let(:white_shirt_amount) { 8 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [1_488_000.0, 112_000.0, 7]
        end

        context 'with total amount < 7' do
          let(:white_shirt_amount) { 3 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 not applied discount', 600_000.0
        end
      end

      context 'buy only tie' do
        context 'with total amount = 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 7 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [455_700.0, 34_300.0, 7]
        end

        context 'with total amount > 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 8 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [520_800.0, 39_200.0, 7]
        end

        context 'with total amount < 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 3 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 0 %
          it_behaves_like 'Ex3 not applied discount', 210_000.0
        end
      end

      context 'buy only other product' do
        context 'with total amount = 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 7 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [65_100.0, 4900.0, 7]
        end

        context 'with total amount > 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 8 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 applied discount', [74_400.0, 5600.0, 7]
        end

        context 'with total amount < 7' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 5 }
          it_behaves_like 'expect instance value of service'
          # discount 7 %
          it_behaves_like 'Ex3 not applied discount', 50_000.0
        end
      end

      context 'do not buy anything' do
        context 'all input is 0' do
          let(:white_shirt_amount) { 0 }
          let(:tie_amount) { 0 }
          let(:hat_amount) { 0 }
          it_behaves_like 'expect instance value of service'
          # discount 0 %
          it_behaves_like 'Ex3 not applied discount', 0
        end

        context 'all input is empty' do
          let(:white_shirt_amount) { "" }
          let(:tie_amount) { "" }
          let(:hat_amount) { "" }
          it_behaves_like 'expect instance value of service'
          # discount 0 %
          it_behaves_like 'Ex3 not applied discount', 0
        end

        context 'other is not present' do
          let(:params) do
            {
              white_shirt_amount: "",
              tie_amount: "",
              other: {},
            }
          end
          # discount 0 %
          it_behaves_like 'Ex3 not applied discount', 0
        end
      end
    end
  end
end
