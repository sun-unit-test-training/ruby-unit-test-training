class Exercise3Controller < ApplicationController
  def index
    calulate = Exercise3::CalculateService.new(params_permit)
    data = calulate.perform
    @total_price = data[:total_price]
    @discount_percent = data[:discount_percent]
    @discount_price = data[:discount_price]
    @errors = data[:errors]
  end

  private

  def params_permit
    params.permit(:white_shirt_amount, :tie_amount, other: {})
  end
end
