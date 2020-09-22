class CreateHanoiQuests < ActiveRecord::Migration[6.0]
  def change
    create_table :hanoi_quests do |t|
      t.string :key_result
      t.string :result

      t.timestamps
    end
  end
end
