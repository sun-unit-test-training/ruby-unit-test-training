# gkc_hash_code : 01E9QA59KWM8YA301WTJ4PG4ZW
require 'rails_helper'

RSpec.describe Exercise1Controller, type: :controller do
  describe '#index' do
    let(:time_formatted) { time.strftime('%H:%M') }
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
        expect(assigns(:number_of_cup)).to eq 2
        expect(assigns(:time).hour).to eq 19
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
        expect(assigns(:number_of_cup)).to eq 2
        expect(assigns(:time).hour).to eq 16
        expect(assigns(:time).min).to eq 30
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
          expect(assigns(:number_of_cup)).to eq 2
          expect(assigns(:time).hour).to eq 19
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
          expect(assigns(:number_of_cup)).to eq 2
          expect(assigns(:time).hour).to eq 16
          expect(assigns(:time).min).to eq 30
          expect(assigns(:price_at_time)).to eq 290
          expect(assigns(:price_of_first_cup)).to eq 100
          expect(assigns(:total_price)).to eq 390
        end
      end
    end

    context 'when number_of_cup is invalid' do
      let(:time) { Time.current.change(hour: 16, min: 30) }

      context 'when number_of_cup is negative' do
        let(:params) do
          {
            number_of_cup: -2,
            have_voucher: 0,
            time: time_formatted
          }
        end

        it do
          expect(assigns(:number_of_cup)).to eq 0
        end
      end

      context 'when number_of_cup is not number' do
        context 'when number_of_cup is character' do
          let(:params) do
            {
              number_of_cup: 'abc',
              have_voucher: 0,
              time: time_formatted
            }
          end

          it do
            expect(assigns(:number_of_cup)).to eq 0
          end
        end

        context 'when number_of_cup is float' do
          let(:params) do
            {
              number_of_cup: 2.5,
              have_voucher: 0,
              time: time_formatted
            }
          end

          it do
            expect(assigns(:number_of_cup)).to eq 0
          end
        end
      end
    end

    context 'when time is invalid' do
      context 'when time is out of range' do
        let(:params) do
          {
            number_of_cup: 1,
            have_voucher: 0,
            time: '25:00'
          }
        end

        it do
          expect(assigns(:time)).to be_kind_of(Time)
        end
      end

      context 'when time contain character' do
        let(:params) do
          {
            number_of_cup: 1,
            have_voucher: 0,
            time: 'ab:cd'
          }
        end

        it do
          expect(assigns(:time)).to be_kind_of(Time)
        end
      end
    end
  end
end
