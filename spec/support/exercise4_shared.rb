RSpec.shared_examples "Exercise4::CalendarService#perform" do |success, data, errors|
  it do
    expect(subject.success).to eq success
    expect(subject.data).to eq data
    expect(subject.errors).to eq errors
  end
end
