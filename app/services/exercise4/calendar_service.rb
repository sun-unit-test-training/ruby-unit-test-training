module Exercise4
  class CalendarService
    def initialize(day_in_month = nil)
      @day_in_month = day_in_month
      @errors = {}
      @choose_day = {}
    end

    def perform
      response
    end

    private

    attr_reader :day_in_month

    def calendar_color
      if holiday? || sunday?
        red_color
      elsif saturday?
        blue_color
      else
        black_color
      end
    end

    def param_todate
      @param_todate ||= day_in_month.to_date
    end

    Settings.exercise_4.type_color.each do |value|
      define_method "#{value}_color" do
        { param_todate.day => value }
      end
    end

    def holiday?
      (Settings.exercise_4.holiday.include? param_todate.strftime(Settings.exercise_4.date_month_format))
    end

    def sunday?
      param_todate.sunday?
    end

    def saturday?
      param_todate.saturday?
    end

    def validate_day?
      is_type_date = day_in_month&.match? Settings.validations.date
      return true if day_in_month.present? && is_type_date

      @errors.merge!(day_in_month: :invalid) unless day_in_month.blank?
      false
    end

    def response
      @choose_day = calendar_color if validate_day?
      OpenStruct.new success: validate_day?, data: @choose_day, errors: @errors
    end
  end
end
