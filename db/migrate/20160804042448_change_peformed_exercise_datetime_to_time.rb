class ChangePeformedExerciseDatetimeToTime < ActiveRecord::Migration
  def change
    change_column :performed_exercises,  :scheduled_date, :time
    change_column :consumed_foods, :scheduled_date, :time
  end
end
