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
