class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.datetime :withdrew_at
      t.integer :amount
      t.boolean :is_holiday, default: false
      t.boolean :is_vip_account, default: false

      t.timestamps
    end
  end
end
