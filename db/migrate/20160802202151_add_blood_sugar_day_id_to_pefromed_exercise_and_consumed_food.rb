class AddBloodSugarDayIdToPefromedExerciseAndConsumedFood < ActiveRecord::Migration
  def change
    add_reference :consumed_foods, :blood_sugar_map, index: true, foreign_key: true
    add_reference :performed_exercises, :blood_sugar_map, index: true, foreign_key: true
  end
end
