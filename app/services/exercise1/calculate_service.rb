module Exercise1
  class CalculateService
    attr_accessor :number_of_cup, :time, :have_voucher, :errors, :total, :settings, :validations

    def initialize(number_of_cup = nil, time = nil, have_voucher = nil)
      @validations = Settings.validations
      @settings = Settings.exercise_1
      @number_of_cup = number_of_cup
      @time = time
      @have_voucher = have_voucher
      @errors = {}
      @total = 0
    end

    def perform
      return response(true) if number_of_cup.nil? || time.nil?

      @number_of_cup = validate_number_of_cup
      @time = validate_time
      @total = total_price

      response(true)
    rescue ArgumentError
      response(false)
    end

    private

    def validate_number_of_cup
      return number_of_cup.to_i if number_of_cup.to_s.match?(validations.number)

      errors.merge!(number_of_cup: :invalid)
      raise ArgumentError
    end

    def validate_time
      return Time.zone.parse(time) if time.to_s.match?(validations.time)

      errors.merge!(time: :invalid)
      raise ArgumentError
    end

    def discount_time?
      time.between?(*discount_time)
    end

    def voucher?
      have_voucher == '1'
    end

    def price_at_time
      @price_at_time ||=
        discount_time? ? settings.price_within_discount_time : settings.price_per_cup
    end

    def price_of_first_cup
      @price_of_first_cup ||=
        voucher? ? settings.price_with_voucher : price_at_time
    end

    def total_price
      return 0 unless number_of_cup.positive?

      (number_of_cup - 1) * price_at_time + price_of_first_cup
    end

    def discount_time
      [
        Time.current.change(hour: 16, min: 0, sec: 0),
        Time.current.change(hour: 17, min: 59, sec: 0)
      ]
    end

    def response(result)
      OpenStruct.new(success?: result, total: total, errors: errors)
    end
  end
end
