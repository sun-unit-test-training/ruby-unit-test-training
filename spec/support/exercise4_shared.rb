RSpec.shared_examples "Exercise4::CalendarService#perform" do |success, data, errors|
  it { expect(subject.success).to eq success }
  it { expect(subject.data).to eq data }
  it { expect(subject.errors).to eq errors }
end
