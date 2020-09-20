require "rails_helper"

class DummyController < ApplicationController; end

RSpec.describe CouponModule, type: :controller do
  controller(DummyController) do
    include CouponModule

    def index
      @coupon = given_coupon(params[:total_amount].to_i, params[:give_coupon])

      render nothing: true
    end
  end

  describe "#given_coupon" do
    let(:params) do
      {
        "total_amount": total_amount,
        "give_coupon": give_coupon
      }
    end

    shared_examples "don't get coupont" do |total_amount|
      let(:total_amount) { total_amount }

      it { expect(assigns(:coupon)).to be nil }
    end

    before { get :index, params: params }

    context "when have choose give coupon" do
      let(:give_coupon) { '1' }

      context "when total_amount in range get coupon" do
        context "when total_amount is 10000円" do

          let(:total_amount) { 10000 }

          it { expect(assigns(:coupon)).not_to be nil }
        end

        context "when total_amount is 5000円" do
          let(:total_amount) { 5000 }

          it { expect(assigns(:coupon)).not_to be nil }
        end
      end

      context "when total_amount out of range get coupon" do
        it_behaves_like "don't get coupont", 9999
        it_behaves_like "don't get coupont", 10001
        it_behaves_like "don't get coupont", 4999
        it_behaves_like "don't get coupont", 50001
      end
    end

    context "when don't have choose give coupon" do
      let(:give_coupon) { nil }

      it_behaves_like "don't get coupont", 9999
      it_behaves_like "don't get coupont", 10000
      it_behaves_like "don't get coupont", 10001
      it_behaves_like "don't get coupont", 4999
      it_behaves_like "don't get coupont", 5000
      it_behaves_like "don't get coupont", 50001
    end
  end
end
