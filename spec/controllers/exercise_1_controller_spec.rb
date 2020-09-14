# gkc_hash_code : 01E9QA59KWM8YA301WTJ4PG4ZW
require 'rails_helper'

RSpec.describe Exercise1Controller, type: :controller do
  describe '#index' do
    before do
      travel_to frozen_time
      get :index, params: params
    end

    after { travel_back }

    describe 'when drink without discount time' do
      let(:frozen_time) { Time.current.change(hour: 19) }
      let(:params) do
        {
          number_of_cup: 2,
          have_voucher: 0
        }
      end

      it do
        expect(assigns(:total_price)).to eq 980
      end
    end

    describe 'when drink within discount time' do
      let(:frozen_time) { Time.current.change(hour: 16, min: 30) }
      let(:params) do
        {
          number_of_cup: 2,
          have_voucher: 0
        }
      end

      it do
        expect(assigns(:total_price)).to eq 580
      end
    end

    describe 'when have voucher' do
      describe 'when drink without discount time' do
        let(:frozen_time) { Time.current.change(hour: 19) }
        let(:params) do
          {
            number_of_cup: 2,
            have_voucher: 1
          }
        end

        it do
          expect(assigns(:total_price)).to eq 590
        end
      end

      describe 'when drink within discount time' do
        let(:frozen_time) { Time.current.change(hour: 16, min: 30) }
        let(:params) do
          {
            number_of_cup: 2,
            have_voucher: 1
          }
        end

        it do
          expect(assigns(:total_price)).to eq 390
        end
      end
    end
  end
end
