class BloodSugarMap < ActiveRecord::Base
  has_many :consumed_foods
  has_many :performed_exercises

  validates :tracked_day, presence: true
end
