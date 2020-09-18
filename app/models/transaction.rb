class Transaction < ApplicationRecord
  validates :withdrew_at, :amount, presence: true
  validates :amount, numericality: {
    only_integer: true, greater_than_or_equal_to: 1
  }, allow_nil: true

  def fee
    return 0 if is_vip_account? || free_withdraw_time?

    110
  end

  private

  def free_withdraw_time?
    return false if is_holiday? || withdrew_at.on_weekend?

    free_withdraw_start = withdrew_at.change(hour: 8, min: 45)
    free_withdraw_end = withdrew_at.change(hour: 17, min: 59)
    withdrew_at.between?(free_withdraw_start, free_withdraw_end)
  end
end
