require 'rails_helper'

RSpec.describe Exercise2Controller, type: :controller do
  describe '#new' do
    before { get :new }

    it { expect(assigns(:transaction)).to be_a_new(Transaction) }
  end

  describe '#create' do
    let(:transaction) { Transaction.new params[:transaction] }
    let(:params) do
      {
        transaction: {
          withdrew_at: time,
          amount: amount
        }
      }
    end

    before do
      allow(Transaction).to receive(:new).and_return(transaction)
      post :create, params: params
    end

    context 'when submit invalid data' do
      shared_examples 'not calculate fee' do
        it 'should not calculate fee' do
          expect(assigns(:fee)).to be_nil
          expect(response).to render_template(:new)
        end
      end

      context 'when time is invalid' do
        let(:time) { nil }
        let(:amount) { 20 }

        include_examples 'not calculate fee'
      end

      context 'when amount is invalid' do
        let(:time) { Time.current }

        context 'when amount is not set' do
          let(:amount) { nil }

          include_examples 'not calculate fee'
        end

        context 'when amount is not a number' do
          let(:amount) { 'abc' }

          include_examples 'not calculate fee'
        end

        context 'when amount is not an integer' do
          let(:amount) { 1.5 }

          include_examples 'not calculate fee'
        end

        context 'when amount is less than 1' do
          let(:amount) { 0 }

          include_examples 'not calculate fee'
        end
      end
    end

    context 'when submit valid data' do
      let(:time) { Time.current }
      let(:amount) { 1 }

      it 'should calculate fee' do
        expect(assigns(:fee)).not_to be_nil
        expect(response).to render_template(:new)
      end

      it 'should assigns transaction' do
        expect(assigns(:transaction)).to eq transaction
      end

      it "should call 'fee'" do
        expect(transaction).to receive(:fee)
        post :create, params: params
      end
    end
  end
end
