module Exercise7
  class CalculateService
    def initialize(total_amount, fast_delivery, premium)
      @validations = Settings.validations
      @premium = premium
      @total_amount = total_amount
      @fast_delivery = fast_delivery
      @errors = {}
      @delivery_fee = 0
    end

    def perform
      return response(true) if @total_amount.nil?

      @total_amount = validate_total_amount(@total_amount)
      @fast_delivery = validate_checkbox_value(:fast_delivery, @fast_delivery)
      @premium = validate_checkbox_value(:premium, @premium)

      @normal_delivery_price = @premium || @total_amount >= 5000 ? 0 : 500
      @fast_delivery_price = @fast_delivery ? 500 : 0
      @delivery_fee = @normal_delivery_price + @fast_delivery_price

      response(true)
    rescue ArgumentError
      response(false)
    end

    private

    def validate_total_amount(number)
      return number.to_i if number.to_s.match?(@validations.number)

      @errors.merge!(total_amount: :invalid)
      raise ArgumentError
    end

    def validate_checkbox_value(attr, value)
      return value == '1' if %w[0 1].include?(value)

      @errors.merge!(attr => :invalid)
      raise ArgumentError
    end

    def response(result)
      OpenStruct.new(success?: result, delivery_fee: @delivery_fee, errors: @errors)
    end
  end
end
