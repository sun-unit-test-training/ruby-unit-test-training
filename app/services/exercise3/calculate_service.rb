module Exercise3
  class CalculateService
    def initialize(white_shirt_amount, tie_amount, hat_amount)
      @validation = Settings.validations.number
      @settings = Settings.exercise_3
      @white_shirt_amount = white_shirt_amount
      @tie_amount = tie_amount
      @hat_amount = hat_amount
      @errors = {}
      @total_price = 0
      @discount_price = 0
      @discount_percent = 0
    end

    def perform
      return data(true) if @white_shirt_amount.blank? && @tie_amount.blank? && @hat_amount.blank?

      @white_shirt_amount = validate_input_number(@white_shirt_amount, :white_shirt_amount)
      @tie_amount = validate_input_number(@tie_amount, :tie_amount)
      @hat_amount = validate_input_number(@hat_amount, :hat_amount)

      return data(false) if @errors.present?

      calculate_discount_percent
      calculate_discount_price
      calculate_total_price
      data(true)
    end

    private

    def validate_input_number(input, field)
      return input.to_i if input.to_s.match?(@validation)

      @errors.merge!(field => :invalid)
    end

    def calculate_discount_percent
      @discount_percent += 7 if (@white_shirt_amount + @tie_amount + @hat_amount) >= 7

      @discount_percent += 5 if @white_shirt_amount.positive? && @tie_amount.positive?
    end

    def calculate_discount_price
      @discount_price = (total * @discount_percent.to_f / 100).round(1)
    end

    def calculate_total_price
      @total_price = total - @discount_price
    end

    def total
      @white_shirt_amount * @settings.price_white_shirt +
        @tie_amount * @settings.price_tie +
        @hat_amount * @settings.price_hat
    end

    def data(status)
      OpenStruct.new(
        success?: status,
        discount_percent: @discount_percent,
        total_price: @total_price,
        discount_price: @discount_price,
        errors: @errors
      )
    end
  end
end
