class Transaction < ApplicationRecord
  validates :withdrew_at, :amount, presence: true
  validates :amount, numericality: {
    only_integer: true, greater_than_or_equal_to: 1
  }, allow_nil: true

  def fee
    return 0 if is_vip_account?

    return 110 if is_holiday? || withdrew_at.on_weekend?

    free_withdraw_start = withdrew_at.change(hour: 8, min: 45)
    free_withdraw_end = withdrew_at.change(hour: 17, min: 59)
    return 0 if withdrew_at.between?(free_withdraw_start, free_withdraw_end)

    110
  end
end
