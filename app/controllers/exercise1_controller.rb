class Exercise1Controller < ApplicationController
  def index
    response = Exercise1::CalculateService.new(params[:number_of_cup].to_i, params[:time], params[:have_voucher])
                                          .perform
    @total_price = response.total
    @errors = response.errors
  end
end
