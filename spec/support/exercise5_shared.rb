RSpec.shared_examples "Exercise5::CalculateService#perform" do |success, total, promotion, errors|
  it do
    expect(subject.success?).to eq success
    expect(subject.total).to eq total
    expect(subject.promotion).to eq promotion
    expect(subject.errors).to eq errors
  end
end
