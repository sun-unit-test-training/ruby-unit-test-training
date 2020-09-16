module Exercise6
  class CalculateFreeParkingTimeService
    def initialize(amount, watch_movie)
      @settings = Settings.exercise_6
      @validations = Settings.validations
      @amount = amount
      @watch_movie = watch_movie
      @total_free_parking_time = 0
      @errors = {}
    end

    def perform
      @amount = validate_amount(@amount)
      @total_free_parking_time += @settings.extra_free_parking_time_for_movie if @watch_movie == 'true'

      if @amount >= @settings.discount_level_1 && @amount < @settings.discount_level_2
        @total_free_parking_time += @settings.level_1_free_parking_time
      elsif @amount >= @settings.discount_level_2
        @total_free_parking_time += @settings.level_2_free_parking_time
      end

      response
    rescue ArgumentError
      response
    end

    private

    def validate_amount(number)
      return number.to_i if number.to_s.match?(@validations.number)

      @errors.merge!(amount: :invalid)
      raise ArgumentError
    end

    def response
      OpenStruct.new(total_free_parking_time: @total_free_parking_time, errors: @errors)
    end
  end
end
