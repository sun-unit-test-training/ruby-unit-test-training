require 'rails_helper'

RSpec.describe Exercise4Controller, type: :controller do
  describe '#index' do
    let(:error) {{}}

    before { get :index, params: params }

    shared_examples 'calendar color' do
      let(:params) {{ day_in_month: day_in_month }}

      it do
        expect(assigns(:choose_day)).to eq calendar_color
        expect(assigns(:errors)).to eq error
      end
    end

    context 'when day_in_month is holiday' do
      context 'and day_in_month is sunday' do
        let(:day_in_month) { "2020-9-27" }
        let(:calendar_color) {{ 27=>"red" }}

        include_examples 'calendar color', :calendar_color, :error
      end

      context 'and day_in_month is saturday' do
        let(:day_in_month) { "2020-9-05" }
        let(:calendar_color) {{ 5=>"red" }}

        include_examples 'calendar color', :calendar_color, :error
      end

      context 'when day_in_month is normal day' do
        let(:day_in_month) { "2020-9-02" }
        let(:calendar_color) {{ 2=>"red" }}

        include_examples 'calendar color', :calendar_color, :error
      end
    end

    context 'when day_in_month is satuday' do
      let(:day_in_month) {"2020-9-12" }
      let(:calendar_color) {{ 12=>"blue" }}

      include_examples 'calendar color', :calendar_color, :error
    end

    context 'when day_in_month is sunday' do
      let(:day_in_month) { "2020-9-20" }
      let(:calendar_color) {{ 20=>"red" }}

      include_examples 'calendar color', :calendar_color, :error
    end

    context 'when day_in_month is normal day' do
      let(:day_in_month) { "2020-9-10" }
      let(:calendar_color) {{ 10=>"black" }}

      include_examples 'calendar color', :calendar_color, :error
    end

    context 'when day_in_month is incorrect format' do
      let(:day_in_month) { "2020-12nnn-22" }
      let(:calendar_color) {{}}
      let(:error) {{:day_in_month=>:invalid}}

      include_examples 'calendar color', :calendar_color, :error
    end

    context 'when params is nil' do
      let(:params) { nil }

      it do
        expect(assigns(:choose_day)).to be_empty
        expect(assigns(:errors)).to be_empty
      end
    end
  end
end
