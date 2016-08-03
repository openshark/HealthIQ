class BloodSugarMapsController < ApplicationController
  def index
    @blood_sugar_maps = BloodSugarMap.paginate(page: params[:page])
  end

  def new
    @blood_sugar_map = BloodSugarMap.new
  end

  def show
    @blood_sugar_map = BloodSugarMap.find(params[:id])
    @exercise_list = Exercise.all
    @food_list = Food.all
  end

  def create
    @blood_sugar_map = BloodSugarMap.new(blood_sugar_map_params)
    if @blood_sugar_map.save
      flash[:success] = "The Day was created!"
      redirect_to @blood_sugar_map
    else
      flash[:error] = "Something went wrong!"
      render 'new'
    end
  end





  private

    def blood_sugar_map_params
      params.require(:blood_sugar_map).permit(:tracked_day, :comment)
    end
end
