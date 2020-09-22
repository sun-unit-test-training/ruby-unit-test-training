module Exercise3
  class CalculateService
    def initialize(params_permit = {})
      @white_shirt_amount = params_permit[:white_shirt_amount]
      @tie_amount = params_permit[:tie_amount]
      @other = params_permit[:other]
      @data = {
        errors: {},
        total_price: 0,
        discount_price: 0,
        discount_percent: 0
      }
    end

    def perform
      return @data if @white_shirt_amount.blank? && @tie_amount.blank? && @other.blank?

      @validation = Settings.validations.number
      @settings = Settings.exercise_3
      validate_params
      return @data if @data[:errors].present?

      calculate_discount_percent
      calculate_discount_price
      calculate_total_price
      @data
    end

    private

    def validate_params
      @white_shirt_amount = validate_input_number(@white_shirt_amount, :white_shirt_amount)
      @tie_amount = validate_input_number(@tie_amount, :tie_amount)
      @other.each_key do |k|
        @other[k] = validate_input_number(@other[k], k.to_sym)
      end
    end

    def validate_input_number(input, field)
      return input.to_i if input.to_s.match?(@validation)

      @data[:errors].merge!(field => :invalid)
    end

    def calculate_discount_percent
      @data[:discount_percent] += @settings.discount_7 if (@white_shirt_amount + @tie_amount + other_amount) >= 7

      @data[:discount_percent] += @settings.discount_5 if @white_shirt_amount.positive? && @tie_amount.positive?
    end

    def calculate_discount_price
      @data[:discount_price] = (total * @data[:discount_percent].to_f / 100).round(1)
    end

    def calculate_total_price
      @data[:total_price] = total - @data[:discount_price]
    end

    def total
      @white_shirt_amount * @settings.white_shirt_price +
        @tie_amount * @settings.tie_price + total_other
    end

    def total_other
      price = 0
      @other.each_key do |k|
        other_setting_key = k.to_s.gsub('amount', 'price')
        price += @other[k] * @settings.other[other_setting_key]
      end
      price
    end

    def other_amount
      @other.values.map(&:to_i).inject(&:+)
    end
  end
end
