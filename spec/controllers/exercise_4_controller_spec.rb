require 'rails_helper'

RSpec.describe Exercise4Controller, type: :controller do
  describe '#index' do
    before { get :index, params: params }

    shared_examples 'calendar color' do
      let(:params) {{ day_in_month: day_in_month }}
      it { expect(assigns(:choose_day)).to eq calerdar_color }
    end

    context 'when day_in_month is holiday' do
      context 'and day_in_month is sunday' do
        let(:day_in_month) { DateTime.new(2020,9,27).strftime('%Y-%m-%d') }
        let(:calerdar_color) {{ 27=>"red" }}
        include_examples 'calendar color'
      end

      context 'and day_in_month is saturday' do
        let(:day_in_month) { DateTime.new(2020,9,05).strftime('%Y-%m-%d') }
        let(:calerdar_color) {{ 5=>"red" }}
        include_examples 'calendar color'
      end

      context 'when day_in_month is normal day' do
        let(:day_in_month) { DateTime.new(2020,9,02).strftime('%Y-%m-%d') }
        let(:calerdar_color) {{ 2=>"red" }}
        include_examples 'calendar color'
      end
    end

    context 'when day_in_month is satuday' do
      let(:day_in_month) { DateTime.new(2020,9,12).strftime('%Y-%m-%d') }
      let(:calerdar_color) {{ 12=>"blue" }}
      include_examples 'calendar color'
    end

    context 'when day_in_month is sunday' do
      let(:day_in_month) { DateTime.new(2020,9,20).strftime('%Y-%m-%d') }
      let(:calerdar_color) {{ 20=>"red" }}
      include_examples 'calendar color'
    end

    context 'when day_in_month is normal day' do
      let(:day_in_month) { DateTime.new(2020,9,10).strftime('%Y-%m-%d') }
      let(:calerdar_color) {{ 10=>"black" }}
      include_examples 'calendar color'
    end

    context 'when day_in_month is incorrect format' do
      let(:params) {{ day_in_month: "2020-12nnn-22" }}
      it { expect(assigns(:errors)).to eq ({:day_in_month=>:invalid}) }
    end

    context 'when params is nil' do
      let(:params) {{ day_in_month: nil }}
      it { expect(assigns(:errors)).to eq ({}) }
    end
  end
end
