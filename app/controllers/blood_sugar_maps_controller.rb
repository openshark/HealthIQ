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
    @performed_exercise = PerformedExercise.new
    @consumed_food = ConsumedFood.new

    @blood_sugar_array = Array.new(1440) # 24 hours x 60 minutes
    # @normalization_array = Array.new(1440) # 24 hours x 60 minutes
    @glycation_array = Array.new(1440) # 24 hours x 60 minutes
    calculate_blood_sugar_array
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


  protected

    def calculate_blood_sugar_array
      logger.debug "calculate_blood_sugar_array"

      add_each_performed_exercise
      add_each_consumed_food
      calculate_glycation_and_normalization
    end

    def calculate_glycation_and_normalization
      logger.debug "Starting calculate_glycation"
      blood_sugar_running_total = 80 # 80 comes from the base level of blood sugar for a person
      number_of_nils_in_a_row = 0
      glycemic_running_total = 0
      @blood_sugar_array.each_with_index do |value, index|
        if value == nil
          number_of_nils_in_a_row = number_of_nils_in_a_row + 1
          @blood_sugar_array[index] = blood_sugar_running_total
        else
          number_of_nils_in_a_row = 0
          @blood_sugar_array[index] = blood_sugar_running_total + @blood_sugar_array[index]
        end

#Check if normilzation needs to happen
        if (number_of_nils_in_a_row >= 60) # TODO - magin number - (it has been more than 1 or 2 hours)
          #normilzation begins
          if blood_sugar_running_total > 80
            @blood_sugar_array[index] = @blood_sugar_array[index] - 1
            #TODO - magic number - this is because the normilzation happens at a rate of 1 unit per minute
          end
           if blood_sugar_running_total < 80
            @blood_sugar_array[index] = @blood_sugar_array[index] + 1
            #TODO - magic number - this is because the normilzation happens at a rate of 1 unit per minute
          end
        end

        # if @normalization_array[index] != nil
        #   @blood_sugar_array[index] = @normalization_array[index] + @blood_sugar_array[index]
        # end
        blood_sugar_running_total = @blood_sugar_array[index]

        if blood_sugar_running_total > 150 # 150 comes from the value when the sugar in your blood cristalizes - TODO remove magic number
          glycemic_running_total = glycemic_running_total + 1
        end
        @glycation_array[index] = glycemic_running_total
      end
    end

    def add_each_consumed_food
      logger.debug "starting add_each_consumed_food"
      #add food performed
      @blood_sugar_map.consumed_foods.each do |consumed_food|
        hours = consumed_food.scheduled_date.strftime("%H")
        minutes = consumed_food.scheduled_date.strftime("%M")
        logger.debug "hours = " + hours
        logger.debug "minutes = " + minutes

        base_index = (hours.to_i * 60) + minutes.to_i
        logger.debug "base_index " + base_index.to_s

        slope = consumed_food.food.glycemic_index.to_f / 120.0     # 120 - 2 hours


#TODO - this should be made into it's own method
        # 120 - 2 hours
        (0..119).each do |minute_offset|
          if ((base_index + minute_offset) < @blood_sugar_array.length)
            if @blood_sugar_array[base_index + minute_offset] == nil
              @blood_sugar_array[base_index + minute_offset] = 0
            end
            @blood_sugar_array[base_index + minute_offset] = (@blood_sugar_array[base_index + minute_offset] + slope)
          end
        end


      end
    end

    def add_each_performed_exercise
      # logger.debug "Start add_each_performed_exercise"
      @blood_sugar_map.performed_exercises.each  do |performed_exercise|
        # logger.debug "walking through exercises"
        # logger.debug performed_exercise.scheduled_date

        hours = performed_exercise.scheduled_date.strftime("%H")
        minutes = performed_exercise.scheduled_date.strftime("%M")
        # logger.debug "hours = " + hours
        # logger.debug "minutes = " + minutes
        base_index = (hours.to_i * 60) + minutes.to_i     # 60 - 1 hour
        # logger.debug "base_index " + base_index.to_s

        # logger.debug "Exercise " + performed_exercise.exercise.name + " exercise index = " + performed_exercise.exercise.exercise_index.to_s
        slope = performed_exercise.exercise.exercise_index.to_f / 60.0 # 60 - 1 hour
        # logger.debug "Slope = " + slope.to_s

        # 60 - 1 hour
        (0..59).each do |minute_offset|
          if ((base_index + minute_offset) < @blood_sugar_array.length)
            if @blood_sugar_array[base_index + minute_offset] == nil
              @blood_sugar_array[base_index + minute_offset] = 0
            end
            @blood_sugar_array[base_index + minute_offset] = (@blood_sugar_array[base_index + minute_offset] - slope)
          end
        end

      end

    end

  private

    def blood_sugar_map_params
      params.require(:blood_sugar_map).permit(:tracked_day, :comment)
    end
end
