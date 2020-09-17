require 'rails_helper'

RSpec.describe Exercise6::CalculateFreeParkingTimeService, type: :service do
  describe '#perform' do
    let(:response) { described_class.new(total_amount, watch_movie).perform }

    context 'when did not watched movie' do
      let(:watch_movie) { false }

      context 'when total amount less than 2000' do
        let(:total_amount) { 1000 }

        it { expect(response[:total_free_parking_time]).to eq 0 }
      end

      context 'when total amount greater 2000 and less than 5000' do
        let(:total_amount) { 2001 }

        it { expect(response[:total_free_parking_time]).to eq 60 }
      end

      context 'when total amount is 2000' do
        let(:total_amount) { 2000 }

        it { expect(response[:total_free_parking_time]).to eq 60 }
      end

      context 'when total amount greater than 5000' do
        let(:total_amount) { 5001 }

        it { expect(response[:total_free_parking_time]).to eq 120 }
      end

      context 'when total amount is 5000' do
        let(:total_amount) { 5000 }

        it { expect(response[:total_free_parking_time]).to eq 120 }
      end
    end

    context 'when watched movie' do
      let(:watch_movie) { 'true' }

      context 'when total amount less than 2000' do
        let(:total_amount) { 1000 }

        it { expect(response[:total_free_parking_time]).to eq 180 }
      end

      context 'when total amount greater 2000 and less than 5000' do
        let(:total_amount) { 2001 }

        it { expect(response[:total_free_parking_time]).to eq 240 }
      end

      context 'when total amount is 2000' do
        let(:total_amount) { 2000 }

        it { expect(response[:total_free_parking_time]).to eq 240 }
      end

      context 'when total amount greater than 5000' do
        let(:total_amount) { 5001 }

        it { expect(response[:total_free_parking_time]).to eq 300 }
      end

      context 'when total amount is 5000' do
        let(:total_amount) { 5000 }

        it { expect(response[:total_free_parking_time]).to eq 300 }
      end
    end

    context 'when invalid params' do
      context 'when amount is not a number' do
        let(:total_amount) { 'abc' }
        let(:watch_movie) { 'true' }

        it { expect(response[:errors][:amount]).to eq :invalid }
      end

      context 'when amount is negative number' do
        let(:total_amount) { -1 }
        let(:watch_movie) { 'true' }

        it { expect(response[:errors][:amount]).to eq :invalid }
      end
    end
  end
end
