class Exercise6Controller < ApplicationController
  def free_parking_time
    @total_free_parking_time = 0
    @errors = {}
  end

  def calculate_free_parking_time
    result = Exercise6::CalculateFreeParkingTimeService.new(params[:amount], params[:watch_movie]).perform
    @total_free_parking_time = result.total_free_parking_time
    @errors = result.errors

    render :free_parking_time
  end
end
