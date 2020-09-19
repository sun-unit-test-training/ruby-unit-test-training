module Exercise10
  class CalculateTotalAmountService
    def initialize(rank, total_amount)
      @rank = rank
      @total_amount = total_amount
      @discount_percent = 0
      @discount_amount = 0
      @errors = {}
    end

    def perform
      return response(false) unless valid_data?

      @total_amount = total_amount.to_i
      calculate_discount

      response true
    end

    private

    attr_reader :rank, :total_amount, :discount_percent, :discount_amount, :errors

    def valid_data?
      validate_total_amount

      errors.blank?
    end

    def validate_total_amount
      return if total_amount.to_s.match?(Settings.validations.number)

      @errors.merge!(total_amount: :invalid)
    end

    def calculate_discount
      return unless Settings.exercise10.rank_bonuses[rank]

      @discount_percent = Settings.exercise10.rank_bonuses[rank][total_amount] || 0
      @discount_amount = total_amount * discount_percent / 100
      @total_amount -= discount_amount
    end

    def response(success)
      OpenStruct.new(
        success?: success,
        discount_percent: discount_percent,
        discount_amount: discount_amount,
        total_amount: total_amount,
        errors: errors
      )
    end
  end
end
