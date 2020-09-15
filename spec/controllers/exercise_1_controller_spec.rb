# gkc_hash_code : 01E9QA59KWM8YA301WTJ4PG4ZW
require 'rails_helper'

RSpec.describe Exercise1Controller, type: :controller do
  describe '#index' do
    let(:time_formatted) { time.strftime('%Y-%m-%dT%H:%M') }
    before { get :index, params: params }

    context 'when drink without discount time' do
      let(:time) { Time.current.change(hour: 19) }
      let(:params) do
        {
          number_of_cup: 2,
          have_voucher: 0,
          time: time_formatted
        }
      end

      it do
        expect(assigns(:price_at_time)).to eq 490
        expect(assigns(:price_of_first_cup)).to eq 490
        expect(assigns(:total_price)).to eq 980
      end
    end

    context 'when drink within discount time' do
      let(:time) { Time.current.change(hour: 16, min: 30) }
      let(:params) do
        {
          number_of_cup: 2,
          have_voucher: 0,
          time: time_formatted
        }
      end

      it do
        expect(assigns(:price_at_time)).to eq 290
        expect(assigns(:price_of_first_cup)).to eq 290
        expect(assigns(:total_price)).to eq 580
      end
    end

    context 'when have voucher' do
      context 'when drink without discount time' do
        let(:time) { Time.current.change(hour: 19) }
        let(:params) do
          {
            number_of_cup: 2,
            have_voucher: 1,
            time: time_formatted
          }
        end

        it do
          expect(assigns(:price_at_time)).to eq 490
          expect(assigns(:price_of_first_cup)).to eq 100
          expect(assigns(:total_price)).to eq 590
        end
      end

      context 'when drink within discount time' do
        let(:time) { Time.current.change(hour: 16, min: 30) }
        let(:params) do
          {
            number_of_cup: 2,
            have_voucher: 1,
            time: time_formatted
          }
        end

        it do
          expect(assigns(:price_at_time)).to eq 290
          expect(assigns(:price_of_first_cup)).to eq 100
          expect(assigns(:total_price)).to eq 390
        end
      end
    end
  end
end
