class Exercise8Controller < ApplicationController
  def index
    data = Exercise8::CalculateTicketPriceService.new(params_permit).perform
    @ticket_price = data[:ticket_price]
    @errors = data[:errors]
  end

  private

  def params_permit
    params.permit(:age, :gender, :ticket_booking_day)
  end
end
