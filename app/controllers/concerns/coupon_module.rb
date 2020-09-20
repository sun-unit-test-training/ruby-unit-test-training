module CouponModule
  extend ActiveSupport::Concern

  included do
    helper_method :amount_in_range_get_coupon?
  end

  private

  def given_coupon(total_amount, give_coupon)
    generate_coupon if enable_given_coupon?(total_amount, give_coupon)
  end

  def generate_coupon
    SecureRandom.alphanumeric
  end

  def enable_given_coupon?(total_amount, give_coupon)
    amount_in_range_get_coupon?(total_amount) && choose_give_coupon?(give_coupon)
  end

  def amount_in_range_get_coupon?(total_amount)
    Settings.exercise10.range_get_coupon.include? total_amount
  end

  def choose_give_coupon?(give_coupon)
    give_coupon == '1'
  end
end
