FactoryBot.define do
  factory :transaction do
    withdrew_at { "2020-09-17 19:06:36" }
    amount { 1 }
    is_holiday { false }
    is_vip_account { false }
  end
end
