require 'rails_helper'

RSpec.describe Exercise7Controller, type: :controller do
  describe '#index' do
    let(:amount) { "10000" }
    let(:fast_delivery) { "0" }
    let(:premium) { "0" }
    let(:delivery_fee) { 123 }
    let(:result) { OpenStruct.new(delivery_fee: delivery_fee, errors: { foo: "bar"}) }
    let(:service_instance) { instance_double(Exercise7::CalculateService, perform: result) }

    it "should initialize service with received params" do
      expect(Exercise7::CalculateService).to receive(:new).with(amount, fast_delivery, premium).and_call_original

      get :index, params: {
        total_amount: amount,
        fast_delivery: fast_delivery,
        premium: premium
      }
    end

    it "should return delivery_fee and errors" do
      allow(Exercise7::CalculateService).to receive(:new).and_return(service_instance)
      get :index

      expect(assigns(:delivery_fee)).to eq(delivery_fee)
      expect(assigns(:errors)).to eq({ foo: "bar"})
      expect(response).to render_template(:index)
    end
  end
end
