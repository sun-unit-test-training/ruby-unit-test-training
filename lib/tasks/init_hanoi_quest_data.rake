namespace :init_hanoi_quest_data do
  task create: :environment do
    HanoiQuest.destroy_all
    Settings.exercise_9.not_find_room.to_h.each do |_, value|
      HanoiQuest.create! key_result: value,
        result: I18n.t("exercise9.index.not_find_room")
    end

    Settings.exercise_9.finded_room.to_h.each do |_, value|
      HanoiQuest.create! key_result: value,
        result: I18n.t("exercise9.index.finded_room")
    end

    Settings.exercise_9.go_into_the_room.to_h.each do |_, value|
      HanoiQuest.create! key_result: value,
        result: I18n.t("exercise9.index.go_into_the_room")
    end

    Settings.exercise_9.defeat_bigboss.to_h.each do |_, value|
      HanoiQuest.create! key_result: value,
        result: I18n.t("exercise9.index.defeat_bigboss")
    end
  end
end
