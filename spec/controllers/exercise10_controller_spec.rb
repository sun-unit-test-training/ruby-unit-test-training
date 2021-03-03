require "rails_helper"

RSpec.describe Exercise10Controller do
  describe "POST checkout" do
    subject { post :checkout, params: params }

    let(:rank) { "silver" }
    let(:total_amount) { "3000" }
    let(:discount_percent) { double :discount_percent }
    let(:discount_amount) { double :discount_amount }
    let(:total_amount_dou) { double :total_amount }
    let(:params) do
      {
        "rank":         rank,
        "total_amount": total_amount,
        "give_coupon":  nil
      }
    end
    let(:stub_response_service) do
      OpenStruct.new(
        success?:         true,
        discount_percent: discount_percent,
        discount_amount:  discount_amount,
        total_amount:     total_amount_dou,
        errors:           {}
      )
    end
    let(:expected_response) { stub_response_service }

    it "return response data" do
      stub_service = instance_double(Exercise10::CalculateTotalAmountService)
      allow(stub_service).to receive(:perform).and_return(stub_response_service)
      allow(Exercise10::CalculateTotalAmountService).to receive(:new).with(rank, total_amount).and_return(stub_service)

      subject

      expect(assigns(:response)).to eq expected_response
      expect(assigns(:coupon)).to eq nil
      expect(assigns(:errors)).to eq expected_response.errors
    end
  end

  describe "GET checkout" do
    context "when get success" do
      before { get :checkout }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
