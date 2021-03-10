require "rails_helper"

RSpec.describe Exercise4Controller, type: :controller do
  describe "#index" do
    subject { get :index, params: params }

    let(:params) { { day_in_month: day_in_month } }
    let(:day_in_month) { "2021-12-31" }
    let(:choose_day) { double :choose_day }
    let(:errors) { double :errors }
    let(:response) { double :response, data: choose_day, errors: errors }
    let(:calendar_service) { Exercise4::CalendarService.new(day_in_month) }

    before do
      allow(Exercise4::CalendarService).to receive(:new).with(day_in_month).and_return(calendar_service)
    end

    it "should initialize service with received params" do
      expect(Exercise4::CalendarService).to receive(:new).with(day_in_month).and_call_original
      subject
    end

    it "should assigns response, choose_day and errors" do
      expect(calendar_service).to receive(:perform).with(no_args).and_return(response)
      subject
      expect(assigns(:response)).to eq response
      expect(assigns(:choose_day)).to eq choose_day
      expect(assigns(:errors)).to eq errors
    end
  end
end
