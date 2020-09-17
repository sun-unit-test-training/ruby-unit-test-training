class Exercise4Controller < ApplicationController
  def index
    @choose_day = {}
    return if params['day_in_month'].blank?

    @choose_day = Exercise4::CalendarService.new(params[:day_in_month]).perform || {}
  end
end
