class PerformedExercise < ActiveRecord::Base

  validates :exercise_id, presence: true
  validates :scheduled_date, presence: true

  belongs_to :exercise
  belongs_to :blood_sugar_map
end
