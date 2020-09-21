class Transaction < ApplicationRecord
  validates :withdrew_at, :amount, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  def fee
    return if invalid?

    return 0 if is_vip_account? || free_withdraw_time?

    110
  end

  private

  def free_withdraw_time?
    return false if is_holiday? || withdrew_at.on_weekend?

    withdrew_time = withdrew_at.strftime(Settings.exercise_2.time_format)
    withdrew_time.between?(Settings.exercise_2.free_withdraw_start_time, Settings.exercise_2.free_withdraw_end_time)
  end
end
