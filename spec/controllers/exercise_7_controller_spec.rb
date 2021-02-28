require 'rails_helper'

RSpec.describe Exercise7Controller, type: :controller do
  describe '#index' do
    let!(:random_amount) { rand(10000).to_s }
    let!(:random_fast_delivery) { [0, 1].sample.to_s }
    let!(:random_premium) { [0, 1].sample.to_s }
    let!(:random_delivery_fee) { rand(500) }
    let(:result) { OpenStruct.new(delivery_fee: random_delivery_fee, errors: { foo: "bar"}) }

    it "should initialize service with received params" do
      expect(Exercise7::CalculateService)
        .to receive(:new).with(random_amount, random_fast_delivery, random_premium).and_call_original

      get :index, params: {
        total_amount: random_amount,
        fast_delivery: random_fast_delivery,
        premium: random_premium
      }
    end

    it "should return delivery_fee and errors" do
      allow_any_instance_of(Exercise7::CalculateService).to receive(:perform).and_return(result)
      get :index

      expect(assigns(:delivery_fee)).to eq(random_delivery_fee)
      expect(assigns(:errors)).to eq({ foo: "bar"})
      expect(response).to render_template(:index)
    end
  end
end
