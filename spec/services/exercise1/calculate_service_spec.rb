require 'rails_helper'

RSpec.describe Exercise1::CalculateService, type: :service do
  describe '#validate_arguments' do
    describe '#number_of_cup' do
      let(:service) { described_class.new(number_of_cup) }
      subject { service.send(:validate_number_of_cup) }

      shared_examples 'invalid number of cup' do |number_of_cup|
        let(:number_of_cup) { number_of_cup }

        it do
          expect { subject }.to raise_error(ArgumentError)
          expect(service.errors[:number_of_cup]).to eq(:invalid)
        end
      end

      context 'when is valid' do
        let(:number_of_cup) { 5 }

        it { expect(subject).to eq(5) }
      end

      context 'when is invalid' do
        context 'when is negative number' do
          it_behaves_like 'invalid number of cup', -5
        end

        context 'when is alphabetic characters' do
          it_behaves_like 'invalid number of cup', 'aa'
        end

        context 'when is float number' do
          it_behaves_like 'invalid number of cup', 2.5
        end
      end
    end

    describe '#time' do
      let(:service) { described_class.new(nil, time) }
      subject { service.send(:validate_time) }

      shared_examples 'invalid time' do |time|
        let(:time) { time }
        
        it do
          expect { subject }.to raise_error(ArgumentError)
          expect(service.errors[:time]).to eq(:invalid)
        end
      end

      context 'when is valid' do
        let(:time) { '12:00' }

        it { expect(subject).to eq(Time.zone.parse(time)) }
      end

      context 'when is invalid' do
        context 'when is out of time range' do
          it_behaves_like 'invalid time', '25:00'
        end

        context 'when contain alphabetic characters' do
          it_behaves_like 'invalid time', 'aa:bb'
        end
      end
    end
  end

  describe '#discount_time?' do
    shared_examples 'is discount time' do |time|
      let(:time) { time }

      it { expect(service.send(:discount_time?)).to eq(true) }
    end

    shared_examples 'is not discount time' do |time|
      let(:time) { time }

      it { expect(service.send(:discount_time?)).to eq(false) }
    end

    let(:service) { described_class.new(nil, time, nil) }

    it_behaves_like 'is discount time', Time.zone.parse('16:00')
    it_behaves_like 'is discount time', Time.zone.parse('17:59')
    it_behaves_like 'is discount time', Time.zone.parse('17:00')

    it_behaves_like 'is not discount time', Time.zone.parse('15:59')
    it_behaves_like 'is not discount time', Time.zone.parse('18:00')
    it_behaves_like 'is not discount time', Time.zone.parse('10:00')
    it_behaves_like 'is not discount time', Time.zone.parse('20:00')
  end

  describe '#voucher?' do
    shared_examples 'have voucher' do |have_voucher|
      let(:have_voucher) { have_voucher }

      it { expect(service.send(:voucher?)).to eq(true) }
    end
    shared_examples 'have no voucher' do |have_voucher|
      let(:have_voucher) { have_voucher }

      it { expect(service.send(:voucher?)).to eq(false) }
    end

    let(:service) { described_class.new(nil, nil, have_voucher) }

    it_behaves_like 'have voucher', '1'
    it_behaves_like 'have no voucher', 0
    it_behaves_like 'have no voucher', '0'
  end

  describe '#price_at_time' do
    shared_examples 'calculate price exactly' do |is_discount_time, price|
      before { expect(service).to receive(:discount_time?).and_return(is_discount_time) }
      
      it { expect(service.send(:price_at_time)).to eq(price) }
    end

    let(:service) { described_class.new }

    it_behaves_like 'calculate price exactly', true, Settings.exercise_1.price_within_discount_time
    it_behaves_like 'calculate price exactly', false, Settings.exercise_1.price_per_cup
  end

  describe '#price_of_first_cup' do
    shared_examples 'calculate price exactly' do |have_voucher, price|
      before { expect(service).to receive(:voucher?).and_return(have_voucher) }
      
      it { expect(service.send(:price_of_first_cup)).to eq(price) }
    end

    let(:service) { described_class.new }

    before do
      allow(service).to receive(:price_at_time).and_return(5)
    end

    it_behaves_like 'calculate price exactly', true, Settings.exercise_1.price_with_voucher
    it_behaves_like 'calculate price exactly', false, 5
  end

  describe '#total_price' do
    shared_examples 'calculate price exactly' do |number_of_cup, price|
      let(:number_of_cup) { number_of_cup }
      
      it { expect(service.send(:total_price)).to eq(price) }
    end

    let(:service) { described_class.new(number_of_cup) }

    before do
      allow(service).to receive(:price_at_time).and_return(5)
      allow(service).to receive(:price_of_first_cup).and_return(3)
    end

    it_behaves_like 'calculate price exactly', 0, 0
    it_behaves_like 'calculate price exactly', -1, 0
    it_behaves_like 'calculate price exactly', 1, 3
    it_behaves_like 'calculate price exactly', 2, 8
    it_behaves_like 'calculate price exactly', 3, 13
  end

  describe '#perform' do
    shared_examples 'calculate price exactly' do |number_of_cup, time, price|
      let(:number_of_cup) { number_of_cup }
      let(:time) { time }

      subject do
        service.perform
      end

      it do
        is_expected.to eq(OpenStruct.new(success?: true, total: price, errors: {}))
      end
    end

    shared_examples 'have errors' do |number_of_cup, time, errors|
      let(:number_of_cup) { number_of_cup }
      let(:time) { time }

      subject { service.perform }

      it do
        is_expected.to eq(OpenStruct.new(success?: false, total: 0, errors: errors))
      end
    end

    let(:service) { described_class.new(number_of_cup, time) }

    context 'when submit valid data' do
      context 'when number_of_cup is nil or time is nil' do
        before do
          expect(service).not_to receive(:validate_number_of_cup)
          expect(service).not_to receive(:validate_time)
          expect(service).not_to receive(:total_price)
        end

        it_behaves_like 'calculate price exactly', nil, '12:00', 0
        it_behaves_like 'calculate price exactly', 3, nil, 0
        it_behaves_like 'calculate price exactly', nil, nil, 0
      end

      context 'when number_of_cup is valid and time is valid' do
        before do
          expect(service).to receive(:validate_number_of_cup).and_call_original
          expect(service).to receive(:validate_time).and_call_original
          expect(service).to receive(:total_price).and_return(123)
        end

        it_behaves_like 'calculate price exactly', 2, '12:00', 123
      end
    end

    context 'when submit invalid data' do
      it_behaves_like 'have errors', -5, '12:00', { number_of_cup: :invalid }
      it_behaves_like 'have errors', 2, 'aa:bb', { time: :invalid }
    end
  end
end
