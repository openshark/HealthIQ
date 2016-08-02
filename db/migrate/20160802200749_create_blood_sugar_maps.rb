class CreateBloodSugarMaps < ActiveRecord::Migration
  def change
    create_table :blood_sugar_maps do |t|
      t.date :tracked_day
      t.text :comment

      t.timestamps null: false
    end

    remove_column :performed_exercises, :exercise_id
    remove_column :consumed_foods, :food_id
  end
end
