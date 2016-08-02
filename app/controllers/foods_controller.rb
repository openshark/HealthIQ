class FoodsController < ApplicationController
  def index
    @foods = Food.paginate(page: params[:page])
  end
end
