require 'rails_helper'

RSpec.describe Exercise5Controller, type: :controller do
  shared_examples "response examples" do |total, promotion|
    it { expect(assigns(:response)[:total]).to eq total }
    it { expect(assigns(:response)[:promotion]).to eq promotion }
  end

  shared_examples "response when param's invalid" do
    it { is_expected.to eq total_bill: :invalid }
  end

  describe '#index' do
    before { get :index, params: params }

    describe 'param validate' do
      subject { assigns(:response)[:errors] }

      context 'when total_bill is negative' do
        let(:params) do
          {
            total_bill: -2,
            have_voucher: nil,
            pickup_at_store: nil
          }
        end

        include_examples "response when param's invalid"
      end

      context 'when total_bill is character' do
        let(:params) do
          {
            total_bill: "abc",
            have_voucher: nil,
            pickup_at_store: nil
          }
        end

        include_examples "response when param's invalid"
      end

      context 'when total_bill is float' do
        let(:params) do
          {
            total_bill: 4.5,
            have_voucher: nil,
            pickup_at_store: nil
          }
        end

        include_examples "response when param's invalid"
      end
    end

    describe 'response logic' do
      context 'when bill over 1500yen' do
        context 'deliver to home' do
          context 'with coupon' do
            let(:params) do
              {
                total_bill: 1501,
                have_voucher: true
              }
            end

            include_examples "response examples", 1201, ["Tặng khoai tây", "Giảm giá 20%"]
          end

          context 'without coupon' do
            let(:params) do
              {
                total_bill: 1501
              }
            end

            include_examples "response examples", 1501, ["Tặng khoai tây"]
          end
        end

        context 'pickup at store' do
          context 'with coupon' do
            let(:params) do
              {
                total_bill: 1501,
                pickup_at_store: true,
                have_voucher: true
              }
            end

            include_examples "response examples", 1501, ["Tặng khoai tây", "Tặng Pizza thứ 2"]
          end

          context 'without coupon' do
            let(:params) do
              {
                total_bill: 1501,
                pickup_at_store: true
              }
            end

            include_examples "response examples", 1501, ["Tặng khoai tây", "Tặng Pizza thứ 2"]
          end
        end
      end

      context 'when bill equal 1500yen' do
        context 'deliver to home' do
          context 'with coupon' do
            let(:params) do
              {
                total_bill: 1500,
                have_voucher: true
              }
            end

            include_examples "response examples", 1200, ["Giảm giá 20%"]
          end

          context 'without coupon' do
            let(:params) do
              {
                total_bill: 1500
              }
            end

            include_examples "response examples", 1500, []
          end
        end

        context 'pickup at store' do
          context 'with coupon' do
            let(:params) do
              {
                total_bill: 1500,
                pickup_at_store: true,
                have_voucher: true
              }
            end

            include_examples "response examples", 1500, ["Tặng Pizza thứ 2"]
          end

          context 'without coupon' do
            let(:params) do
              {
                total_bill: 1500,
                pickup_at_store: true
              }
            end

            include_examples "response examples", 1500, ["Tặng Pizza thứ 2"]
          end
        end
      end

      context 'when bill under 1500yen' do
        context 'deliver to home' do
          context 'with coupon' do
            let(:params) do
              {
                total_bill: 1499,
                have_voucher: true
              }
            end

            include_examples "response examples", 1200, ["Giảm giá 20%"]
          end

          context 'without coupon' do
            let(:params) do
              {
                total_bill: 1499
              }
            end

            include_examples "response examples", 1499, []
          end
        end

        context 'pickup at store' do
          context 'with coupon' do
            let(:params) do
              {
                total_bill: 1499,
                pickup_at_store: true,
                have_voucher: true
              }
            end

            include_examples "response examples", 1499, ["Tặng Pizza thứ 2"]
          end

          context 'without coupon' do
            let(:params) do
              {
                total_bill: 1499,
                pickup_at_store: true
              }
            end

            include_examples "response examples", 1499, ["Tặng Pizza thứ 2"]
          end
        end
      end

      context 'when bill is nil' do
        let(:params) {{}}

        include_examples "response examples", nil, []
      end
    end
  end
end
