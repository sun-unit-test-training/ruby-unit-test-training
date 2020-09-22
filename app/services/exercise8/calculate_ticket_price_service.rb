module Exercise8
  class CalculateTicketPriceService
    def initialize(params_permit = {})
      @age = params_permit[:age]
      @gender = params_permit[:gender]
      @ticket_booking_day = params_permit[:ticket_booking_day]
      @data = {
        errors: {},
        ticket_price: 0
      }
    end

    def perform
      return @data if @age.blank? || @gender.blank? || @ticket_booking_day.blank?

      @validations = Settings.validations
      @settings = Settings.exercise_8
      validate_params
      return @data if @data[:errors].present?

      calculate
      @data
    end

    private

    def validate_params
      validate_age
      validate_gender
      validate_booking_day
    end

    def calculate
      if @ticket_booking_day.tuesday?
        price_in_tuesday
      elsif @ticket_booking_day.friday?
        price_in_friday
      else
        price_in_other_day
      end
    end

    def price_in_tuesday
      @data[:ticket_price] = @settings.badminton_fee_1200
    end

    def price_in_friday
      case @age
      when (0..12)
        @data[:ticket_price] = @settings.badminton_fee_basic / 2
      when (13..64)
        @data[:ticket_price] = @settings.badminton_fee_basic if male?
        @data[:ticket_price] = @settings.badminton_fee_1400 if female?
      else
        @data[:ticket_price] = @settings.badminton_fee_1600 if male?
        @data[:ticket_price] = @settings.badminton_fee_1400 if female?
      end
    end

    def price_in_other_day
      @data[:ticket_price] = case @age
                             when (0..12)
                               @settings.badminton_fee_basic / 2
                             when (13..64)
                               @settings.badminton_fee_basic
                             else
                               @settings.badminton_fee_1600
      end
    end

    def validate_age
      if @age.to_s.match?(@validations.number)
        @age = @age.to_i
        @data[:errors].merge!(age: :invalid) if @age.negative? || @age > 120
      else
        @data[:errors].merge!(age: :invalid)
      end
    end

    def validate_gender
      if @validations.gender.include?(@gender)
        @gender = @gender.to_i
      else
        @data[:errors].merge!(gender: :invalid)
      end
    end

    def validate_booking_day
      if @ticket_booking_day.to_s.match?(@validations.date)
        @ticket_booking_day = Time.zone.parse(@ticket_booking_day.to_s)
        @data[:errors].merge!(ticket_booking_day: :invalid) if @ticket_booking_day < Time.now
      else
        @data[:errors].merge!(ticket_booking_day: :invalid)
      end
    end

    def male?
      @gender == 1
    end

    def female?
      @gender.zero?
    end
  end
end
