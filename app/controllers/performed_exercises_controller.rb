class PerformedExercisesController < ApplicationController

  def new
    @performed_exercise = PerformedExercise.new
    @exercise_list = Exercise.all
  end

  def show
    @performed_exercise = PerformedExercise.find(params[:id])
  end

  def create
    @performed_exercise = PerformedExercise.new(performed_exercise_params)
    if @performed_exercise.save
      flash[:success] = "The exercise was recorded!"
      redirect_to @performed_exercise.blood_sugar_map
    else
      flash[:error] = "something went wrong!"
      render 'new'
    end
  end

  def index
    @performed_exercises = PerformedExercise.paginate(page: params[:page])
  end





  private

  def performed_exercise_params
    params.require(:performed_exercise).permit(:exercise_id, :scheduled_date, :blood_sugar_map_id)
  end
end
