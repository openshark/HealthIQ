class PerformedExercisesController < ApplicationController

  def new
    @performed_exercise = PerformedExercise.new
  end

  def show
  end

  def create
  end

  def index
    @performed_exercises = PerformedExercise.paginate(page: params[:page])
  end
end
