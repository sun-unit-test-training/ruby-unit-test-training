require 'rails_helper'

RSpec.describe Exercise6Controller, type: :controller do
  describe 'GET #free_parking_time' do
    context "when get success" do
      before { get :free_parking_time }

      it do expect(response).to have_http_status(:ok)
        expect(assigns(:errors)).to be_empty
        expect(assigns(:total_free_parking_time)).to eq 0
        expect(response).to render_template :free_parking_time
      end
    end
  end

  describe 'POST #calculate_free_parking_time' do
    before do
      allow_any_instance_of(Exercise6::CalculateFreeParkingTimeService).to receive(:perform).and_return(expected_response)
      post :calculate_free_parking_time
    end

    context 'when service perform successfully' do
      let(:expected_response) {OpenStruct.new success?: true, total_free_parking_time: 200, errors: {}}

      it_behaves_like 'exercise 6 controller success response', free_parking_time: 200
    end

    context 'when service perform failed due to invalid params' do
      let(:expected_response) {OpenStruct.new success?: false, total_free_parking_time: 0, errors: errors}
      let(:errors) {{amount: :invalid}}

      it { expect(assigns(:errors)[:amount]).to eq :invalid }
    end
  end
end
