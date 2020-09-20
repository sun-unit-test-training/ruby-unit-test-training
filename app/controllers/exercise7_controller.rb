class Exercise7Controller < ApplicationController
  def index
    response = Exercise7::CalculateService.new(params[:total_amount], params[:fast_delivery], params[:premium]).perform
    @delivery_fee = response.delivery_fee
    @errors = response.errors
  end
end
