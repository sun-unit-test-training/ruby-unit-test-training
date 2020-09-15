class Exercise1Controller < ApplicationController
  def index
    @total_price = if number_of_cup.positive?
      (number_of_cup - 1) * price_at_time + price_of_first_cup
    else
      0
    end
  end

  private

  def number_of_cup
    @number_of_cup ||=
      params[:number_of_cup]&.match?(validations.number) ? params[:number_of_cup].to_i : 0
  end

  def price_at_time
    @price_at_time ||=
      time.between?(*discount_time) ? settings.price_within_discount_time : settings.price_per_cup
  end

  def price_of_first_cup
    @price_of_first_cup ||=
      params[:have_voucher] == '1' ? settings.price_with_voucher : price_at_time
  end

  def time
    @time ||=
      params[:time].match?(validations.time) ? params[:time].to_time : Time.current
  end

  def discount_time
    [
      Time.current.change(hour: 16, min: 0, sec: 0),
      Time.current.change(hour: 17, min: 59, sec: 0)
    ]
  end

  def settings
    Settings.exercise_1
  end
end
