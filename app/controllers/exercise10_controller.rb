class Exercise10Controller < ApplicationController
  include CouponModule

  def checkout
    return if request.get?

    @response = Exercise10::CalculateTotalAmountService.new(params[:rank], params[:total_amount]).perform
    @errors = @response.errors
    @coupon = given_coupon(params[:total_amount].to_i, params[:give_coupon]) if @response.success?
  end
end
