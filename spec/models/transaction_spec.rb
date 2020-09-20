require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:withdrew_at) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).only_integer.is_greater_than(0) }
  end

  describe '#free_withdraw_time' do
    let(:transaction) { build :transaction }

    subject { transaction.send(:free_withdraw_time?) }

    context 'when it is holiday' do
      before { transaction.is_holiday = true }

      it { is_expected.to eq false }
    end

    context 'when it is weekend' do
      before do
        transaction.is_holiday = false
        travel_to Time.current.end_of_week
      end

      after { travel_back }

      it { is_expected.to eq false }
    end

    context 'when it is not holiday nor weekend' do
      shared_examples 'free withdraw time period' do |time|
        let(:time) { time }

        it { is_expected.to eq true }
      end

      shared_examples 'not free withdraw time period' do |time|
        let(:time) { time }

        it { is_expected.to eq false }
      end

      before do
        transaction.is_holiday = false
        travel_to Time.current.beginning_of_week
        transaction.withdrew_at = Time.zone.parse(time)
      end

      after { travel_back }

      it_should_behave_like 'free withdraw time period', '8:45'
      it_should_behave_like 'free withdraw time period', '17:59:59'
      it_should_behave_like 'free withdraw time period', '13:00'

      it_should_behave_like 'not free withdraw time period', '8:44:59'
      it_should_behave_like 'not free withdraw time period', '18:00'
      it_should_behave_like 'not free withdraw time period', '0:00'
    end
  end

  describe '#fee' do
    let(:transaction) { build :transaction }

    subject { transaction.fee }

    context 'when data is invalid' do
      before { allow(transaction).to receive(:invalid?).and_return true }

      it { is_expected.to be_nil }
    end

    context 'when using vip account' do
      before { transaction.is_vip_account = true }

      it { is_expected.to eq 0 }
    end

    context 'when using vip account' do
      before { transaction.is_vip_account = true }

      it { is_expected.to eq 0 }
    end

    context 'when it is free withdraw time' do
      before do
        transaction.is_vip_account = false
        allow(transaction).to receive(:free_withdraw_time?).and_return true
      end

      it { is_expected.to eq 0 }
    end

    context 'when it is not free withdraw time' do
      before do
        transaction.is_vip_account = false
        allow(transaction).to receive(:free_withdraw_time?).and_return false
      end

      it { is_expected.to eq 110 }
    end
  end
end
