require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @exercise = Exercise.new(name: "squat", exercise_index: 83)
  end

  test "exercise should be valid" do
    assert @exercise.valid?
  end

  test "exercise name should be present" do
    @exercise.name = "     "
    assert_not @exercise.valid?
  end
  test "exercise exercise_index should be present" do
    @exercise.exercise_index = nil
    assert_not @exercise.valid?
  end
end
