class CreatePerformedExercises < ActiveRecord::Migration
  def change
    create_table :performed_exercises do |t|
      t.integer :exercise_id
      t.datetime :scheduled_date

      t.timestamps null: false
    end
  end
end
