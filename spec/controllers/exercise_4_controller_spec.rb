require 'rails_helper'

RSpec.describe Exercise4Controller, type: :controller do
  describe '#index' do
    let(:params) {{ day_in_month: "2020-09-22" }}
    let(:error) {{}}

    shared_examples 'calendar color' do
      it do
        expect(assigns(:choose_day)).to eq calendar_color
        expect(assigns(:errors)).to eq error
      end
    end

    context 'when day_in_month is sunday' do
      let(:calendar_color) {{ 22=>"red" }}

      before do
        allow_any_instance_of(Exercise4::CalendarService).to receive(:sunday?).and_return true
        get :index, params: params
      end

      include_examples 'calendar color', :calendar_color, :error
    end

    context 'when day_in_month is saturday' do
      let(:calendar_color) {{ 22=>"blue" }}

      before do
        allow_any_instance_of(Exercise4::CalendarService).to receive(:saturday?).and_return true
        get :index, params: params
      end

      include_examples 'calendar color', :calendar_color, :error
    end

    context 'when day_in_month is holiday' do
      let(:calendar_color) {{ 22=>"red" }}

      context 'and day_in_month is sunday' do
        before do
          allow_any_instance_of(Exercise4::CalendarService).to receive(:holiday?).and_return true
          allow_any_instance_of(Exercise4::CalendarService).to receive(:sunday?).and_return true

          get :index, params: params
        end

        include_examples 'calendar color', :calendar_color, :error
      end

      context 'and day_in_month is saturday' do
        before do
          allow_any_instance_of(Exercise4::CalendarService).to receive(:holiday?).and_return true
          allow_any_instance_of(Exercise4::CalendarService).to receive(:saturday?).and_return true

          get :index, params: params
        end

        include_examples 'calendar color', :calendar_color, :error
      end

      context 'and day_in_month is normal day' do
        before do
          allow_any_instance_of(Exercise4::CalendarService).to receive(:holiday?).and_return true
          allow_any_instance_of(Exercise4::CalendarService).to receive(:saturday?).and_return false
          allow_any_instance_of(Exercise4::CalendarService).to receive(:sunday?).and_return false

          get :index, params: params
        end
  
        include_examples 'calendar color', :calendar_color, :error
      end
    end

    context 'when day_in_month is normal day' do
      let(:calendar_color) {{ 22=>"black" }}

      before do
        allow_any_instance_of(Exercise4::CalendarService).to receive(:holiday?).and_return false
        allow_any_instance_of(Exercise4::CalendarService).to receive(:saturday?).and_return false
        allow_any_instance_of(Exercise4::CalendarService).to receive(:sunday?).and_return false

        get :index, params: params
      end

      include_examples 'calendar color', :calendar_color, :error
    end
  end
end
