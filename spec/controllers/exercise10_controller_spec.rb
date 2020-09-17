require "rails_helper"

RSpec.describe Exercise10Controller do
  describe "POST checkout" do
    let(:params) do
      {
        "rank"        : rank,
        "total_amount": total_amount,
      }
    end

    before do
      post :checkout, params: params
    end

    context "when checkout susccess" do
      context "when apply discount corresponding with rank and total amount" do
        context "when rank is `SILVER`" do
          let(:rank) { Settings.excercise10.rank.silver }

          context "when total amount is 3000円" do
            let(:total_amount) { 3000 }

            it "return amount discount 1%" do
              expect(assigns(:total_amount)).to eq 2970.0
              expect(assigns(:discount_amount)).to eq 1
              expect(assigns(:discount_amount)).to eq 30.0
            end
          end

          context "when total amount is 5000円" do
            let(:total_amount) { 5000 }

            it "return amount discount 2%" do
              expect(assigns(:total_amount)).to eq 4900.0
              expect(assigns(:discount_amount)).to eq 2
              expect(assigns(:discount_amount)).to eq 100.0
            end
          end

          context "when total amount is 10000円" do
            let(:total_amount) { 10000 }

            it "return amount discount 4%" do
              expect(assigns(:total_amount)).to eq 9600.0
              expect(assigns(:discount_amount)).to eq 4
              expect(assigns(:discount_amount)).to eq 400.0
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
              expect(assigns(:discount_amount)).to eq 3
              expect(assigns(:discount_amount)).to eq 90.0
            end
          end

          context "when total amount is 5000円" do
            let(:total_amount) { 5000 }

            it "return amount discount 5%" do
              expect(assigns(:total_amount)).to eq 4750.0
              expect(assigns(:discount_amount)).to eq 5
              expect(assigns(:discount_amount)).to eq 250.0
            end
          end

          context "when total amount is 10000円" do
            let(:total_amount) { 10000 }

            it "return amount discount 10%" do
              expect(assigns(:total_amount)).to eq 9000.0
              expect(assigns(:discount_amount)).to eq 10
              expect(assigns(:total_amount)).to eq 1000.0
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
              expect(assigns(:discount_amount)).to eq 5
              expect(assigns(:discount_amount)).to eq 150.0
            end
          end

          context "when total amount is 5000円" do
            let(:total_amount) { 5000 }

            it "return amount discount 7%" do
              expect(assigns(:total_amount)).to eq 4650.0
              expect(assigns(:discount_amount)).to eq 7
              expect(assigns(:discount_amount)).to eq 350.0
            end
          end

          context "when total amount is 10000円" do
            let(:total_amount) { 10000 }

            it "return amount discount 15%" do
              expect(assigns(:total_amount)).to eq 8500.0
              expect(assigns(:discount_amount)).to eq 15
              expect(assigns(:discount_amount)).to eq 1500.0
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

        shared_examples "don't has lucky draw" do |total_amount|
          let(:total_amount) { total_amount }

          it do
            expect(assigns(:has_coupon)).to be nil
          end
        end

        context "when has lucky draw" do
          context "when total amount is 5000円" do
            let(:total_amount) { 5000 }

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
          it_behaves_like "don't has lucky draw", 4999
          it_behaves_like "don't has lucky draw", 5001
          it_behaves_like "don't has lucky draw", 9999
          it_behaves_like "don't has lucky draw", 10001
          it_behaves_like "don't has lucky draw", 3000
        end

        context "when draw" do
          let(:total_amount) { 5000 }

          context "when lucky" do
            before do
              allow_any_instance_of(described_class).to receive(:lucky_draw).and_return true
              post :checkout, params: params
            end

            it do
              expect(assigns(:has_coupon)).to be true
            end
          end

          context "when unlucky" do
            before do
              allow_any_instance_of(described_class).to receive(:lucky_draw).and_return false
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
      let(:rank) { 0 }

      context "when total_amount is invalid" do
        context "when total_amount has contains character" do
          let(:total_amount) { "12asdas" }

          it { expect(assigns(:errors)[:total_amount]).to eq :invalid }
        end

        context "when total_amount is a negative" do
          let(:total_amount) { -1 }

          it { expect(assigns(:errors)[:total_amount]).to eq :invalid }
        end
      end
    end
  end

  describe "GET checkout" do
    context "when get success" do
      before { get :checkout }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
