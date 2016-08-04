require 'test_helper'

class ConsumedFoodTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @consumed_food = ConsumedFood.new(food_id: 1, scheduled_date: DateTime.now.strftime("%H:%M:%S"), blood_sugar_map_id: 1)
  end

  test "consumed_food should be valid" do
    assert @consumed_food.valid?
  end

  test "consumed_food food id should be present" do
    @consumed_food.food_id = nil
    assert_not @consumed_food.valid?
  end
  test "consumed_food date should be present" do
    @consumed_food.scheduled_date = nil
    assert_not @consumed_food.valid?
  end
end
