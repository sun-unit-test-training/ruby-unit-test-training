shared_examples 'exercise 6 controller success response' do |argument|
  it { expect(assigns(:total_free_parking_time)).to eq argument[:free_parking_time] }
  it { expect(assigns(:errors)).to be_empty }
end
