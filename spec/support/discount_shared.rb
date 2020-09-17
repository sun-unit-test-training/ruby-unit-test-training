shared_examples "do not discount" do |total_amount|
  let(:total_amount) { total_amount }

  it do
    expect(assigns(:total_amount)).to eq total_amount
    expect(service.discount_percent).to eq 0
    expect(assigns(:discount_amount)).to eq 0
  end
end

shared_examples "out ranger discount" do
  it_behaves_like "do not discount", 2999
  it_behaves_like "do not discount", 3001
  it_behaves_like "do not discount", 4999
  it_behaves_like "do not discount", 5001
  it_behaves_like "do not discount", 9999
  it_behaves_like "do not discount", 10001
end
