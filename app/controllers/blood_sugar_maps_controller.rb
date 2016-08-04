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


  #
  # Input:  blood_sugar_map
  # Outputs: blood_sugar_array, glycation_array
  #
  ############################################################################
  #
  # Takes the exercises and foods logged for a specific day and then produces two
  # arrays for blood sugar through out the day and the glycation throught out the day.
  #
    def calculate_blood_sugar_array
      logger.debug "calculate_blood_sugar_array"

      add_each_performed_exercise
      add_each_consumed_food
      calculate_glycation_and_normalization
    end


    #
    # Input:  blood_sugar_array
    # Outputs: blood_sugar_array, glycation_array
    # Defines / important numbers: normilzation_period_minutes
    #
    ############################################################################
    #
    # Walks through the blood_sugar_array to determain normilzation, by counting nil
    # During the same pass it then takes the base value and walks through to get the final
    # blood sugar value. It then uses that to determain glycation by testinf if
    # The value of the blood sugar is over 150.
    #
    def calculate_glycation_and_normalization
      logger.debug "Starting calculate_glycation"
      blood_sugar_running_total = 80 # 80 comes from the base level of blood sugar for a person
      glycemic_running_total = 0

      # A nil means that no exercise or food affected that specific minute.
      number_of_nils_in_a_row = 0
      @blood_sugar_array.each_with_index do |value, index|
        if value == nil
          number_of_nils_in_a_row = number_of_nils_in_a_row + 1
          @blood_sugar_array[index] = blood_sugar_running_total
        else
          number_of_nils_in_a_row = 0
          @blood_sugar_array[index] = blood_sugar_running_total + @blood_sugar_array[index]
        end

        #Check if normilzation needs to happen
        if (number_of_nils_in_a_row >= @@normalization_period_minutes)
          #normilzation begins
          if blood_sugar_running_total > 80
            @blood_sugar_array[index] = @blood_sugar_array[index] - @@normalization_rate_per_minute
            #normilzation happens at a rate of 1 unit per minute
          end
           if blood_sugar_running_total < 80
            @blood_sugar_array[index] = @blood_sugar_array[index] + @@normalization_rate_per_minute
            #normilzation happens at a rate of 1 unit per minute
          end
        end

        blood_sugar_running_total = @blood_sugar_array[index]

        if blood_sugar_running_total > @@glycation_threshold
          glycemic_running_total = glycemic_running_total + 1
        end
        @glycation_array[index] = glycemic_running_total
      end
    end


    #
    # Input:  blood_sugar_array
    # Outputs: blood_sugar_array
    #
    ############################################################################
    #
    # For each food that is consumed on this day, it walks through them and adds
    # their impact on blood sugar for the given time range.
    #
    def add_each_consumed_food
      logger.debug "starting add_each_consumed_food"
      #add food performed
      @blood_sugar_map.consumed_foods.each do |consumed_food|
        hours = consumed_food.scheduled_date.strftime("%H")
        minutes = consumed_food.scheduled_date.strftime("%M")

        base_index = (hours.to_i * 60) + minutes.to_i
        # logger.debug "base_index " + base_index.to_s

        slope = consumed_food.food.glycemic_index.to_f / @@food_effect_length.to_f

        add_slope_to_exercise_array(@@food_effect_length, base_index, slope)
      end
    end


    #
    # Input:  blood_sugar_array
    # Outputs: blood_sugar_array
    #
    ############################################################################
    #
    # For each exercise that is performed on this day, it walks through them and adds
    # their impact on blood sugar for the given time range.
    #
    def add_each_performed_exercise
      # logger.debug "Start add_each_performed_exercise"
      @blood_sugar_map.performed_exercises.each  do |performed_exercise|
        # logger.debug "walking through exercises"

        hours = performed_exercise.scheduled_date.strftime("%H")
        minutes = performed_exercise.scheduled_date.strftime("%M")

        base_index = (hours.to_i * 60) + minutes.to_i  # 60 - 1 hour

        # logger.debug "Exercise " + performed_exercise.exercise.name + " exercise index = " + performed_exercise.exercise.exercise_index.to_s
        slope = performed_exercise.exercise.exercise_index.to_f / @@exercise_effect_length.to_f

        add_slope_to_exercise_array(@@exercise_effect_length, base_index, -slope)
      end
    end


    #
    # Input:  range - how long the slope affects the array
    #             base_index - where the range begins
    #             slope - the rate of increase or decrease to be applied to the whole range
    # Outputs: none - it affects the blood sugar array though
    #
    ############################################################################
    #
    # Alters the blood sugar array for the given range, starting at the base index
    # at the rate of slope. It also checks if the blood sugar array value is nil
    # that way it can intitalize it if it is the first time that minute is being affected
    #
    def add_slope_to_exercise_array(range, base_index, slope)
      # 60 - 1 hour
      range = range -1
      (0..range).each do |minute_offset|
        if ((base_index + minute_offset) < @blood_sugar_array.length)
          if @blood_sugar_array[base_index + minute_offset] == nil
            @blood_sugar_array[base_index + minute_offset] = 0
          end
          @blood_sugar_array[base_index + minute_offset] = (@blood_sugar_array[base_index + minute_offset] + slope)
        end
      end
    end


  private

    #preventing magic numbers one define at a time!
    @@normalization_period_minutes = 60 #- (it has been more than 1 or 2 hours)
    @@normalization_rate_per_minute = 1 #it will approach 80 linearly at a rate of 1 per minute
    @@glycation_threshold = 150 # 150 comes from the value when the sugar in your blood cristalizes
    @@food_effect_length = 120 # 120 - 2 hours
    @@exercise_effect_length = 60 # 60 - 1 hours


    def blood_sugar_map_params
      params.require(:blood_sugar_map).permit(:tracked_day, :comment)
    end
end
