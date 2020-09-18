module Exercise4
  class CalendarService
    HOLIDAY = %w[01-01 30-04 01-05 02-09 05-09 27-09].freeze
    TYPE_COLOR = %w[red blue black].freeze

    def initialize(day_in_month)
      @day_in_month = day_in_month || ''
      @settings = Settings.exercise_4
      @validations = Settings.validations
      @errors = {}
      @choose_day = {}
    end

    def perform
      response
    end

    private

    attr_reader :day_in_month, :validations, :settings

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

    TYPE_COLOR.each do |value|
      define_method "#{value}_color" do
        { param_todate.day => value }
      end
    end

    def holiday?
      (HOLIDAY.include? param_todate.strftime(settings.date_month_format))
    end

    def sunday?
      param_todate.sunday?
    end

    def saturday?
      param_todate.saturday?
    end

    def validate_day?
      is_type_date = day_in_month.match?(validations.date)
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
