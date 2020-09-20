module Exercise10Helper
  def ranks_select_options
    Settings.exercise10.ranks.map { |rank| [rank.humanize, rank] }
  end
end
