class AddReferencesToConsumedFoodAndPerformedExercise < ActiveRecord::Migration
  def change
    add_reference :performed_exercises, :exercise, index: true
    add_reference :consumed_foods, :food, index: true
  end
end
