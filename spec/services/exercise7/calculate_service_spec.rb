require 'rails_helper'

RSpec.describe Exercise7::CalculateService, type: :service do
  describe '#new' do
    let(:service) { Exercise7::CalculateService }

    # args: total_amount, fast_delivery, premium
    context 'when pass enought args' do
      it { expect { service.new(1000, '1', '1') }.to_not raise_error }
      it { expect { service.new(1000, '1', '1').perform }.to_not raise_error }
      it { expect { service.new(0, '1', '1') }.to_not raise_error }
      it { expect { service.new(0, '1', '1').perform }.to_not raise_error }
      it { expect { service.new(nil, nil, nil) }.to_not raise_error }
      it { expect { service.new(nil, nil, nil).perform }.to_not raise_error }

      context 'when pass mess args' do
        it { expect { service.new(true, Date.current, Time.current) }.to_not raise_error }
        it { expect { service.new(true, Date.current, Time.current).perform }.to_not raise_error }
      end
    end

    context 'when miss args' do
      it { expect { service.new(1) }.to raise_error }
    end
  end

  describe '#perform' do
    let(:service) { Exercise7::CalculateService.new(*args) }

    describe 'validate args' do
      let(:response) { service.perform }

      context 'when total_amount is negative' do
        let(:args) { [-2, '1', '1'] }

        it { expect(response.errors[:number_of_cup]).to eq :invalid }
      end

      context 'when total_amount is text' do
        let(:args) { ['a', '1', '1'] }

        it { expect(response.errors[:number_of_cup]).to eq :invalid }
      end

      context 'when fast_delivery is integer' do
        let(:args) { [2, 1, '1'] }

        it do
          response
          expect(service.instance_values['fast_delivery']).to eq false
        end
      end

      context 'when fast_delivery is text' do
        let(:args) { [2, 'a', '1'] }

        it do
          response
          expect(service.instance_values['fast_delivery']).to eq false
        end
      end

      context 'when premium is integer' do
        let(:args) { [2, '1', 1] }

        it do
          response
          expect(service.instance_values['premium']).to eq false
        end
      end

      context 'when premium is text' do
        let(:args) { [2, '1', 'a'] }

        it do
          response
          expect(service.instance_values['premium']).to eq false
        end
      end
    end

    describe 'calculate logic' do
      let(:args) { [total_amount, fast_delivery, premium] }

      share_examples 'calculate logic tests' do |premium, total_amount, fast_delivery, normal_delivery_price, fast_delivery_price, delivery_fee|
        it do
          response = service.perform
          expect(service.instance_values['premium']).to eq premium
          expect(service.instance_values['total_amount']).to eq total_amount
          expect(service.instance_values['fast_delivery']).to eq fast_delivery
          expect(service.instance_values['normal_delivery_price']).to eq normal_delivery_price
          expect(service.instance_values['fast_delivery_price']).to eq fast_delivery_price
          expect(response.delivery_fee).to eq delivery_fee
        end
      end

      context 'when user is not premium member' do
        let(:premium) { '0' }

        context 'when total_amount is less than 5000' do
          let(:total_amount) { 4999 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            include_examples 'calculate logic tests', false, 4999, false, 500, 0, 500
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            include_examples 'calculate logic tests', false, 4999, true, 500, 500, 1000
          end
        end

        context 'when total_amount is equal than 5000' do
          let(:total_amount) { 5000 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            include_examples 'calculate logic tests', false, 5000, false, 0, 0, 0
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            include_examples 'calculate logic tests', false, 5000, true, 0, 500, 500
          end
        end

        context 'when total_amount is greater than 5000' do
          let(:total_amount) { 5001 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            include_examples 'calculate logic tests', false, 5001 , false, 0, 0, 0
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            include_examples 'calculate logic tests', false, 5001, true, 0, 500, 500
          end
        end
      end

      context 'when user is premium member' do
        let(:premium) { '1' }

        context 'when total_amount is less than 5000' do
          let(:total_amount) { 4999 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            include_examples 'calculate logic tests', true, 4999, false, 0, 0, 0
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            include_examples 'calculate logic tests', true, 4999, true, 0, 500, 500
          end
        end

        context 'when total_amount is equal than 5000' do
          let(:total_amount) { 5000 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            include_examples 'calculate logic tests', true, 5000, false, 0, 0, 0
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            include_examples 'calculate logic tests', true, 5000, true, 0, 500, 500
          end
        end

        context 'when total_amount is greater than 5000' do
          let(:total_amount) { 5001 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            include_examples 'calculate logic tests', true, 5001, false, 0, 0, 0
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            include_examples 'calculate logic tests', true, 5001, true, 0, 500, 500
          end
        end
      end
    end
  end
end
