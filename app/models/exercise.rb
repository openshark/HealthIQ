class Exercise < ActiveRecord::Base
  validates :name, presence: true
  validates :exercise_index, presence: true
end
