class Exercise1Controller < ApplicationController
  def index
    @total_price = if number_of_cup > 0
      (number_of_cup - 1) * price_at_time + price_of_first_cup
    else
      0
    end
  end

  private

  def discount_time
    [
      Time.current.change(hour: 16, min: 0, sec: 0),
      Time.current.change(hour: 17, min: 59, sec: 0)
    ]
  end

  def number_of_cup
    params[:number_of_cup].to_i > 0 ? params[:number_of_cup].to_i : 0
  end

  def price_at_time
    @price_at_time ||=
      time.between?(*discount_time) ? Settings.excercise_1.discount_per_cup : Settings.excercise_1.price_per_cup
  end

  def price_of_first_cup
    @price_of_first_cup ||=
      params[:have_voucher] == '1' ? Settings.excercise_1.price_with_voucher : price_at_time
  end

  def time
    params[:time] ? params[:time].to_time : Time.current
  end
end
