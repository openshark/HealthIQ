class ConsumedFood < ActiveRecord::Base

  validates :food_id, presence: true
  validates :scheduled_date, presence: true

  belongs_to :food
end
