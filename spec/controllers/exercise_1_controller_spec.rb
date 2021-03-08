require 'rails_helper'

RSpec.describe Exercise1Controller, type: :controller do
  describe '#index' do
    context 'initialize Exercise1::CalculateService with correct params' do
      let(:params) do
        {
          number_of_cup: 2,
          time: '12:00',
          have_voucher: '1'
        }
      end

      it do
        expect(Exercise1::CalculateService).to receive(:new).with(
          params[:number_of_cup].to_s,
          params[:time],
          params[:have_voucher]
        ).and_call_original

        get :index, params: params
      end
    end

    context 'assigns result of service to correct instance variables' do
      shared_examples 'assigns correct instance variables' do |result, total_price, errors|
        let(:response) do
          OpenStruct.new(success?: result, total: total_price, errors: errors)
        end

        before do
          allow_any_instance_of(Exercise1::CalculateService).to receive(:perform).and_return(response)

          get :index, params: {}
        end

        it { expect(assigns(:total_price)).to eq(total_price) }
        it { expect(assigns(:errors)).to eq(errors) }
      end

      it_behaves_like 'assigns correct instance variables', true, 100, {}
      it_behaves_like 'assigns correct instance variables', false, 0, { number_of_cup: :invalid }
      it_behaves_like 'assigns correct instance variables', false, 0, { time: :invalid }
    end
  end
end
