class Exercise5Controller < ApplicationController
  def index
    @response = Exercise5::CalculateService.new(params[:total_bill], params[:pickup_at_store],
                                                params[:have_voucher]).perform
  end
end
