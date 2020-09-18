class Exercise4Controller < ApplicationController
  def index
    @response = Exercise4::CalendarService.new(params[:day_in_month]).perform
    @choose_day = @response.data
    @errors = @response.errors
  end
end
