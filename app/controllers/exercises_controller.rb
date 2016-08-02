class ExercisesController < ApplicationController

  def index
    @exercises = Exercise.paginate(page: params[:page])
  end
end
