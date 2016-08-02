class PerformedExercise < ActiveRecord::Base

  validates :exercise_id, presence: true
  validates :scheduled_date, presence: true

  belongs_to :exercise
end
