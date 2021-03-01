require "rails_helper"

RSpec.describe Exercise5Controller, type: :controller do
  describe "#index" do
    subject { get :index, params: params}

    let(:total_bill) { "1000" }
    let(:pickup_at_store) { "true" }
    let(:have_voucher) { "true" }
    let(:params) do
      {
        total_bill: total_bill,
        pickup_at_store: pickup_at_store,
        have_voucher: have_voucher
      }
    end
    let(:response) { double :response }

    it "should initialize service with received params" do
      expect(Exercise5::CalculateService).to receive(:new)
        .with(total_bill, pickup_at_store, have_voucher)
        .and_call_original

      subject
    end

    it "should assigns response" do
      allow_any_instance_of(Exercise5::CalculateService).to receive(:perform)
        .with(no_args)
        .and_return(response)

      subject
      expect(assigns(:response)).to eq response
    end
  end
end
