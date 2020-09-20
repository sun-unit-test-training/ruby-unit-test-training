class Exercise3Controller < ApplicationController
  def index
    calulate = Exercise3::CalculateService.new(params[:white_shirt_amount], params[:tie_amount], params[:hat_amount])
    data = calulate.perform
    @total_price = data.total_price
    @discount_percent = data.discount_percent
    @discount_price = data.discount_price
    @errors = data.errors
  end
end
