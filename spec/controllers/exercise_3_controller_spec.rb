require 'rails_helper'

RSpec.describe Exercise3Controller, type: :controller do
  describe '#index' do
    shared_examples 'do not applied discount' do |total_price|
      let(:total_price) { total_price }

      it do
        expect(assigns(:total_price)).to eq total_price
        expect(assigns(:discount_percent)).to eq 0
        expect(assigns(:discount_price)).to eq 0
      end
    end

    shared_examples 'applied discount 12 %' do |total_price|
      let(:total_price) { total_price }
      let(:discount_price) { discount_price }
      it do
        expect(assigns(:total_price)).to eq total_price
        expect(assigns(:discount_percent)).to eq 12
        expect(assigns(:discount_price)).to eq discount_price
      end
    end

    shared_examples 'applied discount 7 %' do |total_price|
      let(:total_price) { total_price }
      let(:discount_price) { discount_price }
      it do
        expect(assigns(:total_price)).to eq total_price
        expect(assigns(:discount_percent)).to eq 7
        expect(assigns(:discount_price)).to eq discount_price
      end
    end

    shared_examples 'tie_amount invalid' do
      let(:params) do
        {
          white_shirt_amount: 0,
          tie_amount: tie_amount,
          hat_amount: 0,
        }
      end
      it { expect(assigns(:errors)[:tie_amount]).to eq :invalid }
    end

    shared_examples 'white_shirt_amount invalid' do
      let(:params) do
        {
          white_shirt_amount: white_shirt_amount,
          tie_amount: 0,
          hat_amount: 0,
        }
      end
      it { expect(assigns(:errors)[:white_shirt_amount]).to eq :invalid }
    end

    shared_examples 'hat_amount invalid' do
      let(:params) do
        {
          white_shirt_amount: 0,
          tie_amount: 0,
          hat_amount: hat_amount,
        }
      end
      it { expect(assigns(:errors)[:hat_amount]).to eq :invalid }
    end

    before { get :index, params: params }

    context 'when input data invalid' do
      context 'white_shirt_amount is negative' do
        let(:white_shirt_amount) { -1 }

        it_behaves_like 'white_shirt_amount invalid'
      end

      context 'white_shirt_amount is not number' do
        let(:white_shirt_amount) { 'abc123' }

        it_behaves_like 'white_shirt_amount invalid'
      end

      context 'tie_amount is negative' do
        let(:tie_amount) { -1 }

       it_behaves_like 'tie_amount invalid'
      end

      context 'tie_amount is not number' do
        let(:tie_amount) { '123abc' }

        it_behaves_like 'tie_amount invalid'
      end

      context 'hat_amount is negative' do
        let(:hat_amount) { -1 }

        it_behaves_like 'hat_amount invalid'
      end

      context 'hat_amount is not number' do
        let(:hat_amount) { '123abc' }

        it_behaves_like 'hat_amount invalid'
      end
    end

    context 'when input data valid' do
      context 'buy white-shirts and tie' do
        context 'with total amount = 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 4,
              hat_amount: 0,
            }
          end

          it_behaves_like 'applied discount 12 %', 774_400.0, 105_600.0
        end

        context 'total amount > 7' do
          let(:params) do
            {
              white_shirt_amount: 4,
              tie_amount: 4,
              hat_amount: 0,
            }
          end

          it_behaves_like 'applied discount 12 %', 950_400.0, 129_600.0
        end

        context 'total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 2,
              hat_amount: 0,
            }
          end

          it 'return total price with discount is 5 %' do
            expect(assigns(:discount_percent)).to eq 5
            expect(assigns(:discount_price)).to eq 37_000.0
            expect(assigns(:total_price)).to eq 703_000.0
          end
        end
      end

      context 'buy white-shirts and other_product' do
        context 'with total amount = 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 0,
              hat_amount: 4,
            }
          end

          it_behaves_like 'applied discount 7 %', 595_200.0, 44_800.0
        end

        context 'with total amount > 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 0,
              hat_amount: 5,
            }
          end

          it_behaves_like 'applied discount 7 %', 1_023_000.0, 77_000.0
        end

        context 'with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 0,
              hat_amount: 2,
            }
          end

          it_behaves_like 'do not applied discount', 620_000
        end
      end

      context 'buy tie and other_product' do
        context 'with total amount = 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 3,
              hat_amount: 4,
            }
          end

          it_behaves_like 'applied discount 7 %', 232_500.0, 17_500.0
        end

        context 'with total amount > 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 4,
              hat_amount: 4,
            }
          end

          it_behaves_like 'applied discount 7 %', 297_600.0, 22_400.0
        end

        context 'with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 2,
              hat_amount: 1,
            }
          end

          it_behaves_like 'do not applied discount', 150_000
        end
      end

      context 'buy only white-shirts' do
        context 'with total amount = 7' do
          let(:params) do
            {
              white_shirt_amount: 7,
              tie_amount: 0,
              hat_amount: 0,
            }
          end

          it_behaves_like 'applied discount 7 %', 1_302_000.0, 98_000.0
        end

        context 'with total amount > 7' do
          let(:params) do
            {
              white_shirt_amount: 8,
              tie_amount: 0,
              hat_amount: 0,
            }
          end

          it_behaves_like 'applied discount 7 %', 1_488_000.0, 112_000.0
        end

        context 'total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 3,
              tie_amount: 0,
              hat_amount: 0,
            }
          end

          it_behaves_like "do not applied discount", 600_000.0
        end
      end

      context 'buy only tie'
        context 'with total amount = 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 7,
              hat_amount: 0,
            }
          end

          it_behaves_like 'applied discount 7 %', 455_700.0, 34_300.0
        end

        context 'total amount > 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 8,
              hat_amount: 0,
            }
          end

          it_behaves_like 'applied discount 7 %', 520_800.0, 39_200.0
        end

        context 'with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 3,
              hat_amount: 0,
            }
          end

          it_behaves_like "do not applied discount", 210_000.0
        end
      end

      context 'buy only other product' do
        context 'with total amount = 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 0,
              hat_amount: 7,
            }
          end

          it_behaves_like 'applied discount 7 %', 65_100.0, 4900.0
        end

        context 'with total amount > 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 0,
              hat_amount: 8,
            }
          end

          it_behaves_like 'applied discount 7 %', 74_400.0, 5600.0
        end

        context 'with total amount < 7' do
          let(:params) do
            {
              white_shirt_amount: 0,
              tie_amount: 0,
              hat_amount: 5,
            }
          end

          it_behaves_like "do not applied discount", 50_000.0
        end
      end

      context 'do not buy anything' do
        let(:params) do
          {
            white_shirt_amount: 0,
            tie_amount: 0,
            hat_amount: 0,
          }
        end

        it_behaves_like "do not applied discount", 0
      end
    end
  end
end
