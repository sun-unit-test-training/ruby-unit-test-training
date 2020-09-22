module Exercise8
  class CalculateTicketPriceService
    module Gender
      FEMALE = 0
      MALE = 1
    end

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
      return data if age.blank? || gender.blank? || ticket_booking_day.blank?

      @validations = Settings.validations
      @settings = Settings.exercise_8
      validate_params
      return data if data[:errors].present?

      calculate
      data
    end

    private

    attr_reader :age, :gender, :ticket_booking_day, :validations, :settings, :data

    def validate_params
      validate_age
      validate_gender
      validate_booking_day
    end

    def calculate
      @data[:ticket_price] = if ticket_booking_day.tuesday?
        price_in_tuesday
      elsif ticket_booking_day.friday?
        price_in_friday
      else
        price_in_other_day
      end
    end

    def price_in_tuesday
      settings.badminton_fee_1200
    end

    def price_in_friday
      case age
      when (0..12)
        settings.badminton_fee_basic / 2
      when (13..64)
        return settings.badminton_fee_1400 if female?

        settings.badminton_fee_basic
      else
        return settings.badminton_fee_1400 if female?

        settings.badminton_fee_1600
      end
    end

    def price_in_other_day
      case age
      when (0..12)
        settings.badminton_fee_basic / 2
      when (13..64)
        settings.badminton_fee_basic
      else
        settings.badminton_fee_1600
      end
    end

    def validate_age
      if age.to_s.match?(validations.number) && age.to_i >= 0 && age.to_i <= 120
        @age = age.to_i
      else
        data[:errors].merge!(age: :invalid)
      end
    end

    def validate_gender
      if validations.gender.include?(gender)
        @gender = gender.to_i
      else
        data[:errors].merge!(gender: :invalid)
      end
    end

    def validate_booking_day
      if ticket_booking_day.to_s.match?(validations.date)
        @ticket_booking_day = Time.zone.parse(ticket_booking_day.to_s)
        check_invalid_time
      else
        data[:errors].merge!(ticket_booking_day: :invalid)
      end
    end

    def check_invalid_time
      data[:errors].merge!(ticket_booking_day: :invalid) if ticket_booking_day < Time.now
    end

    def female?
      gender == Gender::FEMALE
    end
  end
end
