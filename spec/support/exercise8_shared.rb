shared_examples 'Ex8 expect ticket_booking_day' do |price_args|
  context 'ticket_booking_day is Tuesday' do
    # mock ticket_booking_day is Tuesday
    let(:ticket_booking_day) { Time.now.next_occurring(:tuesday) }

    it { expect(assigns(:ticket_price)).to eq price_args[0] }
  end

  context 'ticket_booking_day is Friday' do
    # mock ticket_booking_day is Tuesday
    let(:ticket_booking_day) { Time.now.next_occurring(:friday) }

    it { expect(assigns(:ticket_price)).to eq price_args[1] }
  end

  context 'not Tuesday and Friday' do
    # mock ticket_booking_day isn't both Tuesday and Friday
    let(:ticket_booking_day) { Time.now.next_occurring(:wednesday) }

    it { expect(assigns(:ticket_price)).to eq price_args[2] }
  end
end

shared_examples 'Ex8 input data for service invalid' do |field|
  it { expect(data[:errors][field]).to eq :invalid }
end

shared_examples 'Ex8 expect instance value of service' do
  it do
    expect(service.instance_values['age']).to eq params[:age]
    expect(service.instance_values['gender']).to eq params[:gender]
    expect(service.instance_values['ticket_booking_day']).to eq params[:ticket_booking_day]
  end
end

shared_examples 'Ex8 calculate ticket_booking_day' do |price_args|
  context 'ticket_booking_day is Tuesday' do
    let(:ticket_booking_day) { Time.now.next_occurring(:tuesday) }

    it { expect(data[:ticket_price]).to eq price_args[0] }
  end

  context 'ticket_booking_day is Friday' do
    let(:ticket_booking_day) { Time.now.next_occurring(:friday) }

    it { expect(data[:ticket_price]).to eq price_args[1] }
  end

  context 'not Tuesday and Friday' do
    let(:ticket_booking_day) { Time.now.next_occurring(:wednesday) }

    it { expect(data[:ticket_price]).to eq price_args[2] }
  end
end
