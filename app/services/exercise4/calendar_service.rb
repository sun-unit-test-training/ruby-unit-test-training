module Exercise4
  class CalendarService
    HOLIDAY = %w[01-01 30-04 01-05 02-09 05-09 27-09].freeze
    TYPE_COLOR = %w[red blue black].freeze

    def initialize(day_in_month)
      @day_in_month = day_in_month
    end

    def perform
      calendar
    end

    private

    def calendar
      if sun_holiday? || sat_holiday?
        red_color
      elsif saturday?
        blue_color
      else
        black_color
      end
    end

    def param_todate
      @param_todate ||= @day_in_month.to_date
    end

    def sun_holiday?
      (HOLIDAY.include? param_todate.strftime(Settings.exercise_4.date_month_format)) ||
        param_todate.sunday?
    end

    def saturday?
      param_todate.saturday?
    end

    def sat_holiday?
      saturday? && (HOLIDAY.include? param_todate.strftime(Settings.exercise_4.date_month_format))
    end

    TYPE_COLOR.each do |value|
      define_method "#{value}_color" do
        { param_todate.day => value }
      end
    end
  end
end
