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
      @amount = validate_amount @amount
      @total_free_parking_time += settings.extra_free_parking_time_for_movie if watched_movie?

      if amount_match_first_level_discount?
        @total_free_parking_time += settings.level_1_free_parking_time
      elsif amount_match_second_level_discount?
        @total_free_parking_time += settings.level_2_free_parking_time
      end

      response true
    rescue ArgumentError
      response false
    end

    private

    attr_reader :settings, :validations, :watch_movie

    def watched_movie?
      watch_movie == 'true'
    end

    def amount_match_first_level_discount?
      @amount >= settings.discount_level_1 && @amount < settings.discount_level_2
    end

    def amount_match_second_level_discount?
      @amount >= settings.discount_level_2
    end

    def validate_amount(number)
      return number.to_i if number.to_s.match?(validations.number)

      @errors.merge!(amount: :invalid)
      raise ArgumentError
    end

    def response(result)
      OpenStruct.new success?: result, total_free_parking_time: @total_free_parking_time, errors: @errors
    end
  end
end
