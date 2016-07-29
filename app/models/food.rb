class Food < ActiveRecord::Base
  validates :name, presence: true
  validates :glycemic_index, presence: true
end
