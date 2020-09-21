require 'rails_helper'

RSpec.describe Exercise7Controller, type: :controller do
  describe '#index' do
    before { get :index, params: params }

    context 'when params is valid' do
      let(:params) do
        {
          premium: premium,
          total_amount: total_amount,
          fast_delivery: fast_delivery
        }
      end

      context 'when user is not premium member' do
        let(:premium) { '0' }

        context 'when total_amount is less than 5000' do
          let(:total_amount) { 4999 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            it { expect(assigns(:delivery_fee)).to eq 500 }
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            it { expect(assigns(:delivery_fee)).to eq 1000 }
          end
        end

        context 'when total_amount is equal than 5000' do
          let(:total_amount) { 5000 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            it { expect(assigns(:delivery_fee)).to eq 0 }
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            it { expect(assigns(:delivery_fee)).to eq 500 }
          end
        end

        context 'when total_amount is greater than 5000' do
          let(:total_amount) { 5001 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            it { expect(assigns(:delivery_fee)).to eq 0 }
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            it { expect(assigns(:delivery_fee)).to eq 500 }
          end
        end
      end

      context 'when user is premium member' do
        let(:premium) { '1' }

        context 'when total_amount is less than 5000' do
          let(:total_amount) { 4999 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            it { expect(assigns(:delivery_fee)).to eq 0 }
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            it { expect(assigns(:delivery_fee)).to eq 500 }
          end
        end

        context 'when total_amount is equal than 5000' do
          let(:total_amount) { 5000 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            it { expect(assigns(:delivery_fee)).to eq 0 }
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            it { expect(assigns(:delivery_fee)).to eq 500 }
          end
        end

        context 'when total_amount is greater than 5000' do
          let(:total_amount) { 5001 }

          context 'when do not have fast_delivery' do
            let(:fast_delivery) { '0' }

            it { expect(assigns(:delivery_fee)).to eq 0 }
          end

          context 'when have fast_delivery' do
            let(:fast_delivery) { '1' }

            it { expect(assigns(:delivery_fee)).to eq 500 }
          end
        end
      end
    end

    context 'when params is invalid' do
      shared_examples 'invalid params' do |param|
        it do
          expect(assigns(:delivery_fee)).to eq 0
          expect(assigns(:errors)[param]).to eq :invalid
        end
      end

      context 'when total_amount is negative number' do
        let(:params) do
          {
            premium: '1',
            total_amount: -1,
            fast_delivery: '1'
          }
        end

        include_examples('invalid params', :total_amount)
      end

      context 'when total_amount is text' do
        let(:params) do
          {
            premium: '1',
            total_amount: 'abc',
            fast_delivery: '1'
          }
        end

        include_examples('invalid params', :total_amount)
      end
    end
  end
end
