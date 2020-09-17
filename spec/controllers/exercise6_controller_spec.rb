require 'rails_helper'

RSpec.describe Exercise6Controller, type: :controller do
  describe 'GET #free_parking_time' do
    context "when get success" do
      before { get :free_parking_time }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template :free_parking_time }
    end
  end

  describe 'POST #calculate_free_parking_time' do
    let(:params) do
      {
        amount: total_amount,
        watch_movie:  watch_movie
      }
    end

    before do
      post :calculate_free_parking_time, params: params
    end

    context 'when did not watched movie' do
      let(:watch_movie) { false }

      context 'when total amount less than 2000' do
        let(:total_amount) { 1000 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 0
      end

      context 'when total amount greater 2000 and less than 5000' do
        let(:total_amount) { 2001 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 60
      end

      context 'when total amount is 2000' do
        let(:total_amount) { 2000 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 60
      end

      context 'when total amount greater than 5000' do
        let(:total_amount) { 5001 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 120
      end

      context 'when total amount is 5000' do
        let(:total_amount) { 5000 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 120
      end
    end

    context 'when watched movie' do
      let(:watch_movie) { 'true' }

      context 'when total amount less than 2000' do
        let(:total_amount) { 1000 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 180
      end

      context 'when total amount greater 2000 and less than 5000' do
        let(:total_amount) { 2001 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 240
      end

      context 'when total amount is 2000' do
        let(:total_amount) { 2000 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 240
      end

      context 'when total amount greater than 5000' do
        let(:total_amount) { 5001 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 300
      end

      context 'when total amount is 5000' do
        let(:total_amount) { 5000 }

        it_behaves_like 'exercise 6 controller success response', free_parking_time: 300
      end
    end

    context 'when invalid params' do
      context 'when amount is not a number' do
        let(:total_amount) { 'abc' }
        let(:watch_movie) { 'true' }

        it { expect(assigns(:errors)[:amount]).to eq :invalid }
      end

      context 'when amount is negative number' do
        let(:total_amount) { -1 }
        let(:watch_movie) { 'true' }

        it { expect(assigns(:errors)[:amount]).to eq :invalid }
      end
    end
  end
end
