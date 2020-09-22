require 'rails_helper'

RSpec.describe Exercise8::CalculateTicketPriceService, type: :service do
  before(:all) { travel_to('2020-09-21 01:00:00') }
  after(:all) { travel_back }
  let(:params) {
    {
      age: age,
      gender: gender,
      ticket_booking_day: ticket_booking_day
    }
  }
  describe '#new' do
    let(:service) { Exercise8::CalculateTicketPriceService }
    context 'when pass enought args' do
      let(:age) { 2 }
      let(:gender) { '1' }
      let(:ticket_booking_day) { Time.now.tomorrow }
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
    let(:service) { Exercise8::CalculateTicketPriceService.new(params) }
    let(:data) { service.perform }

    describe 'validate params' do
      context 'age is negative' do
        let(:age) { -1 }
        let(:gender) { 1 }
        let(:ticket_booking_day) { Time.now.tomorrow }

        it_behaves_like 'Ex8 input data for service invalid', :age
      end

      context 'age is greater than 120' do
        let(:age) { 121 }
        let(:gender) { 1 }
        let(:ticket_booking_day) { Time.now.tomorrow }

        it_behaves_like 'Ex8 input data for service invalid', :age
      end

      context 'gender invalid' do
        let(:age) { 1 }
        let(:gender) { 'abcd' }
        let(:ticket_booking_day) { Time.now.tomorrow }

        it_behaves_like 'Ex8 input data for service invalid', :gender
      end

      context 'ticket_booking_day invalid' do
        let(:age) { 1 }
        let(:gender) { 0 }
        context 'ticket_booking_day is not date' do
          let(:ticket_booking_day) { 'abc' }

          it_behaves_like 'Ex8 input data for service invalid', :ticket_booking_day
        end

        context 'ticket_booking_day is yesterday' do
          let(:ticket_booking_day) { Time.now.yesterday }

          it_behaves_like 'Ex8 input data for service invalid', :ticket_booking_day
        end
      end
    end

    describe 'calculate logic' do
      context 'when 0 <= age < 13' do
        context 'age = 0' do
          let(:age) { 0 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 900, 900]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 900, 900]
          end
        end

        context 'age = 12' do
          let(:age) { 12 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 900, 900]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 900, 900]
          end
        end
      end

      context 'when 13 <= age <= 64' do
        context 'age = 13' do
          let(:age) { 13 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1800, 1800]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1800]
          end
        end

        context 'age = 14' do
          let(:age) { 14 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1800, 1800]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1800]
          end
        end

        context 'age = 63' do
          let(:age) { 63 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1800, 1800]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1800]
          end
        end

        context 'age = 64' do
          let(:age) { 64 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1800, 1800]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1800]
          end
        end
      end

      context 'when 65 <= age <= 120' do
        context 'age = 65' do
          let(:age) { 65 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1600, 1600]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1600]
          end
        end

        context 'age = 66' do
          let(:age) { 66 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1600, 1600]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1600]
          end
        end

        context 'age = 119' do
          let(:age) { 119 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1600, 1600]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1600]
          end
        end

        context 'age = 120' do
          let(:age) { 120 }
          context 'is male' do
            let(:gender) { 1 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1600, 1600]
          end

          context 'is female' do
            let(:gender) { 0 }

            it_behaves_like 'Ex8 calculate ticket_booking_day', [1200, 1400, 1600]
          end
        end

        context 'when age is empty' do
          let(:age) { '' }
          let(:gender) { 0 }
          let(:ticket_booking_day) { Time.now.tomorrow }
          it { expect(data[:ticket_price]).to eq 0 }
        end
  
        context 'when gender is empty' do
          let(:age) { 2 }
          let(:gender) { '' }
          let(:ticket_booking_day) { Time.now.tomorrow }
          it { expect(data[:ticket_price]).to eq 0 }
        end
  
        context 'when ticket_booking_day is empty' do
          let(:age) { 2 }
          let(:gender) { '0' }
          let(:ticket_booking_day) { '' }
          it { expect(data[:ticket_price]).to eq 0 }
        end
  
        context 'all input is empty' do
          let(:age) { 2 }
          let(:gender) { '' }
          let(:ticket_booking_day) { '' }
          it { expect(data[:ticket_price]).to eq 0 }
        end
      end
    end
  end
end
