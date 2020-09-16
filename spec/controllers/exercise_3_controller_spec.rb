require 'rails_helper'

RSpec.describe Exercise3Controller, type: :controller do
  describe '#index' do
    let!(:price_white_shirt) { Settings.exercise_3.price_white_shirt }
    let!(:price_tie) { Settings.exercise_3.price_tie }
    let!(:price_trousers) { Settings.exercise_3.price_trousers }
    before { get :index, params: params }

    context 'when discount is not applied' do
      context 'buy only white-shirts' do
        let(:params) do
          {
            white_shirt_amount: 3,
            tie_amount: 0,
            trousers_amount: 0,
          }
        end

        it 'return total price of white-shirts' do
          expect_total_price = params[:white_shirt_amount] * price_white_shirt
          expect(assigns(:total_price)).to eq expect_total_price
        end
      end

      context 'buy white-shirts and trousers with total amount < 7' do
        let(:params) do
          {
            white_shirt_amount: 3,
            tie_amount: 0,
            trousers_amount: 2,
          }
        end

        it 'return total price of both white-shirts and trousers' do
          expect_total_price = params[:white_shirt_amount] * price_white_shirt + params[:trousers_amount] * price_trousers
          expect(assigns(:total_price)).to eq expect_total_price
        end
      end
    end

    context 'when discount is applied' do
      context 'buy only white-shirts with total amount >= 7' do
        let(:params) do
          {
            white_shirt_amount: 7,
            tie_amount: 0,
            trousers_amount: 0,
          }
        end

        it 'return total price with discount is 7 %' do
          expect_total_price = params[:white_shirt_amount] * price_white_shirt * 0.93
          expect(assigns(:total_price)).to eq expect_total_price
        end
      end

      context 'buy white-shirts and tie' do
        context 'with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 2,
              trousers_amount: 0,
            }
          end

          it 'return total price with discount is 5 %' do
            expect_total_price = (params[:white_shirt_amount] * price_white_shirt + params[:tie_amount] * price_tie) * 0.95
            expect(assigns(:total_price)).to eq expect_total_price
          end
        end

        context 'with total amount >= 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 4,
              trousers_amount: 0,
            }
          end

          it 'return total price with discount is 12 %' do
            expect_total_price = (params[:white_shirt_amount] * price_white_shirt + params[:tie_amount] * price_tie) * 0.88
            expect(assigns(:total_price)).to eq expect_total_price
          end
        end
      end

      context 'buy white-shirts and trousers with total amount >= 7' do
        let(:params) do
          {
            white_shirt_amount: 7,
            tie_amount: 0,
            trousers_amount: 1,
          }
        end

        it 'return total price with discount is 7 %' do
          expect_total_price = (params[:white_shirt_amount] * price_white_shirt + params[:trousers_amount] * price_trousers) * 0.93
          expect(assigns(:total_price)).to eq expect_total_price
        end
      end
    end
  end
end
