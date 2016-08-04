class ConsumedFoodsController < ApplicationController
  def new
    @consumed_food = ConsumedFood.new
    @food_list = Food.all
  end

  def show
    @consumed_food = ConsumedFood.find(params[:id])
  end

  def create
    @consumed_food = ConsumedFood.new(consumed_food_params)
    if @consumed_food.save
      flash[:success] = "The food was recorded!"
      redirect_to @consumed_food.blood_sugar_map
    else
      flash[:error] = "Something went wrong!"
      render 'new'
    end
  end

  def index
    @consumed_foods = ConsumedFood.paginate(page: params[:page])
  end





  private

  def consumed_food_params
    params.require(:consumed_food).permit(:food_id, :scheduled_date, :blood_sugar_map_id)
  end
end
