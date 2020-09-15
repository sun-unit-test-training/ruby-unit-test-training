require 'rails_helper'

RSpec.describe Exercise1::CalculateService, type: :service do
  describe '#new' do
    let(:service) { Exercise1::CalculateService }

    context 'when pass enought args' do
      it { expect { service.new(1, '15:00', nil) }.to_not raise_error }
      it { expect { service.new(1, '15:00', nil).perform }.to_not raise_error }
      it { expect { service.new(0, '15:00', nil) }.to_not raise_error }
      it { expect { service.new(0, '15:00', nil).perform }.to_not raise_error }
      it { expect { service.new(nil, nil, nil) }.to_not raise_error }
      it { expect { service.new(nil, nil, nil).perform }.to_not raise_error }

      context 'when pass mess args' do
        it { expect { service.new(Time.current, 1, true) }.to_not raise_error }
        it { expect { service.new(Time.current, 1, true).perform }.to_not raise_error }
      end
    end

    context 'when miss args' do
      it { expect { service.new(1, '15:00') }.to raise_error }
    end
  end

  describe '#perform' do
    let(:time_formatted) { time.strftime('%H:%M') }
    let(:service) { Exercise1::CalculateService.new(*args) }
    let(:response) { service.perform }

    describe 'validate args' do
      context 'when number_of_cup is invalid' do
        let(:time) { Time.current.change(hour: 16, min: 30) }

        context 'when number_of_cup is negative' do
          let(:args) { [-2, time_formatted, 0] }

          it { expect(response.errors[:number_of_cup]).to eq :invalid }
        end

        context 'when number_of_cup is not number' do
          context 'when number_of_cup is character' do
            let(:args) { ['abc', time_formatted, 0] }

            it { expect(response.errors[:number_of_cup]).to eq :invalid }
          end

          context 'when number_of_cup is float' do
            let(:args) { [2.5, time_formatted, 0] }

            it { expect(response.errors[:number_of_cup]).to eq :invalid }
          end
        end
      end

      context 'when time is invalid' do
        context 'when time is out of range' do
          let(:args) { [1, 0, '25:00'] }

          it { expect(response.errors[:time]).to eq :invalid }
        end

        context 'when time contain character' do
          let(:args) { [1, 0, 'ab:cd'] }

          it { expect(response.errors[:time]).to eq :invalid }
        end
      end
    end

    describe 'calculate logic' do
      context 'when drink without discount time' do
        let(:time) { Time.current.change(hour: 19) }
        let(:args) { [2, time_formatted, 0] }

        it do
          response = service.perform
          expect(service.instance_values['number_of_cup']).to eq 2
          expect(service.instance_values['time'].hour).to eq 19
          expect(service.instance_values['price_at_time']).to eq 490
          expect(service.instance_values['price_of_first_cup']).to eq 490
          expect(response.total).to eq 980
        end
      end

      context 'when drink within discount time' do
        let(:time) { Time.current.change(hour: 16, min: 30) }
        let(:args) { [2, time_formatted, 0] }

        it do
          response = service.perform
          expect(service.instance_values['number_of_cup']).to eq 2
          expect(service.instance_values['time'].hour).to eq 16
          expect(service.instance_values['time'].min).to eq 30
          expect(service.instance_values['price_at_time']).to eq 290
          expect(service.instance_values['price_of_first_cup']).to eq 290
          expect(response.total).to eq 580
        end
      end

      context 'when have voucher' do
        context 'when drink without discount time' do
          let(:time) { Time.current.change(hour: 19) }
          let(:args) { [2, time_formatted, '1'] }

          it do
            response = service.perform
            expect(service.instance_values['number_of_cup']).to eq 2
            expect(service.instance_values['time'].hour).to eq 19
            expect(service.instance_values['price_at_time']).to eq 490
            expect(service.instance_values['price_of_first_cup']).to eq 100
            expect(response.total).to eq 590
          end
        end

        context 'when drink within discount time' do
          let(:time) { Time.current.change(hour: 16, min: 30) }
          let(:args) { [2, time_formatted, '1'] }

          it do
            response = service.perform
            expect(service.instance_values['number_of_cup']).to eq 2
            expect(service.instance_values['time'].hour).to eq 16
            expect(service.instance_values['time'].min).to eq 30
            expect(service.instance_values['price_at_time']).to eq 290
            expect(service.instance_values['price_of_first_cup']).to eq 100
            expect(response.total).to eq 390
          end
        end
      end
    end
  end
end
