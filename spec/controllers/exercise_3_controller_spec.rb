require 'rails_helper'

RSpec.describe Exercise3Controller, type: :controller do
  describe '#index' do
    before { get :index, params: params }

    context 'when input data invalid' do
      context 'white_shirt_amount is negative' do
        let(:params) do
          {
            white_shirt_amount: -2,
            tie_amount: 0,
          }
        end

        it { expect(assigns(:errors)[:white_shirt_amount]).to eq :invalid }
      end

      context 'white_shirt_amount is not number' do
        let(:params) do
          {
            white_shirt_amount: 'abc12',
            tie_amount: 0,
          }
        end

        it { expect(assigns(:errors)[:white_shirt_amount]).to eq :invalid }
      end

      context 'tie_amount is negative' do
        let(:params) do
          {
            white_shirt_amount: 0,
            tie_amount: -1,
          }
        end

        it { expect(assigns(:errors)[:tie_amount]).to eq :invalid }
      end

      context 'tie_amount is not number' do
        let(:params) do
          {
            white_shirt_amount: 0,
            tie_amount: '123abc',
          }
        end

        it { expect(assigns(:errors)[:tie_amount]).to eq :invalid }
      end
    end

    context 'when input data valid' do
      context 'when discount is applied' do
        context 'buy white-shirts and tie with total amount >= 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 4,
            }
          end

          it 'return total price with discount is 12 %' do
            expect(assigns(:discount_percent)).to eq 12
            expect(assigns(:total_price)).to eq 774_400.0
          end
        end

        context 'buy only white-shirts with total amount >= 7' do
          let(:params) do
            {
              white_shirt_amount: 7,
              tie_amount: 0,
            }
          end

          it 'return total price with discount is 7 %' do
            expect(assigns(:discount_percent)).to eq 7
            expect(assigns(:total_price)).to eq 1_302_000.0
          end
        end

        context 'buy only tie with total amount >= 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 7,
            }
          end

          it 'return total price with discount is 7 %' do
            expect(assigns(:discount_percent)).to eq 7
            expect(assigns(:total_price)).to eq 455_700.0
          end
        end

        context 'buy white-shirts and tie with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 2,
            }
          end

          it 'return total price with discount is 5 %' do
            expect(assigns(:discount_percent)).to eq 5
            expect(assigns(:total_price)).to eq 703_000.0
          end
        end
      end

      context 'when discount is not applied' do
        context 'buy white-shirts with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 0,
            }
          end

          it 'return total price of white-shirts' do
            expect(assigns(:discount_percent)).to eq 0
            expect(assigns(:total_price)).to eq 600_000.0
          end
        end

        context 'buy tie with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 3,
            }
          end

          it 'return total price of tie' do
            expect(assigns(:discount_percent)).to eq 0
            expect(assigns(:total_price)).to eq 210_000.0
          end
        end

        context 'do not buy anything' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 0,
            }
          end

          it 'return total price is 0' do
            expect(assigns(:discount_percent)).to eq 0
            expect(assigns(:total_price)).to eq 0
          end
        end
      end
    end
  end
end
