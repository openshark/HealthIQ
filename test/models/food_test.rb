require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @food = Food.new(name: "Pizza", glycemic_index: 53)
  end

  test "food should be valid" do
    assert @food.valid?
  end

  test "food name should be present" do
    @food.name = "     "
    assert_not @food.valid?
  end
  test "food glycemic_index should be present" do
    @food.glycemic_index = nil
    assert_not @food.valid?
  end
end
