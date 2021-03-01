RSpec.shared_examples "Exercise5::CalculateService#perform" do |success, total, promotion, errors|
  it { expect(subject.success?).to eq success }
  it { expect(subject.total).to eq total }
  it { expect(subject.promotion).to eq promotion }
  it { expect(subject.errors).to eq errors }
end
