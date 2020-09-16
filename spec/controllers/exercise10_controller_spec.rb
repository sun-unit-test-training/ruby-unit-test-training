require "rails_helper"

RSpec.describe Exercise10Controller do
  describe "POST checkout" do
    context "when checkout susccess" do
      let(:params) do
        {
          "rank"        : rank,
          "total_amount": total_amount,
        }
      end

      before do
        post :checkout, params: params
      end

      context "when apply discount coressponding with rank and total amount" do
        shared_examples "do not discount" do |total_amount|
          let(:total_amount) { total_amount }

          it { expect(assigns(:total_amount)).to eq total_amount }
        end

        shared_examples "out ranger discount" do
          it_behaves_like "do not discount", 2999
          it_behaves_like "do not discount", 3001
          it_behaves_like "do not discount", 4999
          it_behaves_like "do not discount", 5001
          it_behaves_like "do not discount", 9999
          it_behaves_like "do not discount", 10001
        end

        context "when rank is `SILVER`" do
          let(:rank) { Settings.excercise10.rank.silver }

          context "when total amount is 3000円" do
            let(:total_amount) { 3000 }

            it "return amount discount 1%" do
              expect(assigns(:total_amount)).to eq 2970.0
            end
          end

          context "when total amount is 5000円" do
            let(:total_amount) { 5000 }

            it "return amount discount 2%" do
              expect(assigns(:total_amount)).to eq 4900.0
            end
          end

          context "when total amount is 10000円" do
            let(:total_amount) { 10000 }

            it "return amount discount 4%" do
              expect(assigns(:total_amount)).to eq 9600.0
            end
          end

          include_examples "out ranger discount"
        end

        context "when rank is `GOLD`" do
          let(:rank) { Settings.excercise10.rank.gold }

          context "when total amount is 3000円" do
            let(:total_amount) { 3000 }

            it "return amount discount 3%" do
              expect(assigns(:total_amount)).to eq 2910.0
            end
          end

          context "when total amount is 5000円" do
            let(:total_amount) { 5000 }

            it "return amount discount 5%" do
              expect(assigns(:total_amount)).to eq 4750.0
            end
          end

          context "when total amount is 10000円" do
            let(:total_amount) { 10000 }

            it "return amount discount 10%" do
              expect(assigns(:total_amount)).to eq 9000.0
            end
          end

          include_examples "out ranger discount"
        end

        context "when rank is `PLATINUM`" do
          let(:rank) { Settings.excercise10.rank.platinum }

          context "when total amount is 3000円" do
            let(:total_amount) { 3000 }

            it "return amount discount 5%" do
              expect(assigns(:total_amount)).to eq 2850.0
            end
          end

          context "when total amount is 5000円" do
            let(:total_amount) { 5000 }

            it "return amount discount 7%" do
              expect(assigns(:total_amount)).to eq 4650.0
            end
          end

          context "when total amount is 10000円" do
            let(:total_amount) { 10000 }

            it "return amount discount 15%" do
              expect(assigns(:total_amount)).to eq 8500.0
            end
          end

          include_examples "out ranger discount"
        end

        context "when rank is another" do
          let(:rank) { 0 }

          it_behaves_like "do not discount", 3000
          it_behaves_like "do not discount", 5000
          it_behaves_like "do not discount", 10000
        end
      end

      context "lucky draw" do
        let(:rank) { nil }

        context "when has lucky draw" do
          let(:total_amount) { 5000 }

          context "when total amount is 5000円" do
            it do
              expect(assigns(:has_coupon)).not_to be nil
            end
          end

          context "when total amount is 10000円" do
            let(:total_amount) { 10000 }

            it do
              expect(assigns(:has_coupon)).not_to be nil
            end
          end
        end

        context "when don't has lucky draw" do
          let(:total_amount) { 3000 }

          it do
            expect(assigns(:has_coupon)).to be nil
          end
        end

        context "when draw" do
          let(:total_amount) { 5000 }

          context "when lucky" do
            before do
              # percentage lucky draw to get a coupon is 20%
              allow_any_instance_of(described_class).to receive(:rand).with(10).and_return 1
              post :checkout, params: params
            end

            it do
              expect(assigns(:has_coupon)).to be true
            end
          end

          context "when unlucky" do
            before do
              allow_any_instance_of(described_class).to receive(:rand).with(10).and_return 2
              post :checkout, params: params
            end

            it do
              expect(assigns(:has_coupon)).to be false
            end
          end
        end
      end
    end

    context "when checkout failed" do
      context "when total_amount is invalid" do
        let(:total_amount) { "adasd" }

        it { expect(assigns(:errors)[:total_amount]).to eq :invalid }
      end
    end
  end

  describe "GET checkout" do
    context "return http success" do
      before { get :checkout }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
