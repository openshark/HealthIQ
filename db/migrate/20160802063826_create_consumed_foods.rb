class CreateConsumedFoods < ActiveRecord::Migration
  def change
    create_table :consumed_foods do |t|
      t.integer :food_id
      t.datetime :scheduled_date

      t.timestamps null: false
    end
  end
end
