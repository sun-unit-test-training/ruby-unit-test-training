module Exercise5
  class CalculateService
    def initialize(total_bill, pickup_at_store, have_voucher)
      @validations = Settings.validations
      @settings = Settings.exercise_5
      @total_bill = total_bill
      @pickup_at_store = pickup_at_store
      @have_voucher = have_voucher
      @errors = {}
      @promotion = []
    end

    def perform
      return response(true) if total_bill.nil?

      @total_bill = validate_total_bill total_bill
      calculate_promotion
      calculate_discount_at_home

      response true
    rescue ArgumentError
      response false
    end

    private

    attr_accessor :total_bill, :errors, :promotion
    attr_reader :validations, :settings, :pickup_at_store, :have_voucher

    def validate_total_bill(number)
      return number.to_i if number.to_s.match?(validations.number)

      @errors.merge! total_bill: :invalid
      raise ArgumentError
    end

    def response(result)
      OpenStruct.new success?: result, total: total_bill, promotion: promotion, errors: errors
    end

    def calculate_discount_at_home
      return if pickup_at_store.present? || have_voucher.blank?

      @total_bill -= total_bill * settings.discount_with_voucher / 100
      promotion.push I18n.t('exercise5.discount_20_percent')
    end

    def calculate_promotion
      @promotion.push(I18n.t('exercise5.bonus_french_fries')) if total_bill > settings.min_bill_for_discount
      @promotion.push(I18n.t('exercise5.bonus_pizza')) if pickup_at_store
    end
  end
end
