require 'test_helper'

class PerformedExerciseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @performed_exercise = PerformedExercise.new(exercise_id: 1, scheduled_date: DateTime.now)
  end

  test "performed_exercise should be valid" do
    assert @performed_exercise.valid?
  end

  test "performed_exercise exercise id should be present" do
    @performed_exercise.exercise_id = nil
    assert_not @performed_exercise.valid?
  end
  test "performed_exercise date should be present" do
    @performed_exercise.scheduled_date = nil
    assert_not @performed_exercise.valid?
  end

end
