class ConsumedFood < ActiveRecord::Base

  validates :food_id, presence: true
  validates :scheduled_date, presence: true
  validates :blood_sugar_map_id, presence: true

  belongs_to :food
  belongs_to :blood_sugar_map

end
