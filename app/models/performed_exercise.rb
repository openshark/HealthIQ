class PerformedExercise < ActiveRecord::Base

  validates :exercise_id, presence: true
  validates :scheduled_date, presence: true
  validates :blood_sugar_map_id, presence: true

  belongs_to :exercise
  belongs_to :blood_sugar_map
end
