module Exercise10Helper
  def ranks_select_options
    Settings.exercise10.ranks.map { |rank| [rank.humanize, rank] }
  end

  def amount_in_range_get_coupon?(total_amount)
    Settings.exercise10.range_get_coupon.include? total_amount
  end
end
