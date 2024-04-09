# frozen_string_literal: true

class ScanSchedule
  class Repeat
    attr_accessor :day_of_week, :every, :interval, :date_of_month, :last_day_of_month, :week_of_month

    VALID_EVERY_VALUES = %w[hour day week date-of-month day-of-month].freeze

    def initialize(
      every:,
      interval:,
      day_of_week: nil,
      date_of_month: nil,
      last_day_of_month: false,
      week_of_month: nil
    )
      @every = every
      @interval = interval
      @day_of_week = day_of_week
      @date_of_month = date_of_month
      @last_day_of_month = last_day_of_month
      @week_of_month = week_of_month

      validate!
    end

    def to_json(*_args)
      {
        dayOfWeek: day_of_week,
        every:,
        interval:,
        lastDayOfMonth: last_day_of_month,
        weekOfMonth: week_of_month
      }.to_json
    end

    def self.from_json(data)
      ScanSchedule::Repeat.new(
        day_of_week: data['dayOfWeek'],
        every: data['every'],
        interval: data['interval'],
        last_day_of_month: data['lastDayOfMonth'],
        week_of_month: data['weekOfMonth']
      )
    end

    private

    def validate!
      raise ArgumentError, 'Invalid every value' unless VALID_EVERY_VALUES.include?(@every)

      unless @interval.is_a?(Integer) && @interval >= 1
        raise ArgumentError,
              'Interval must be an integer greater than or equal to 1'
      end

      validate_day_of_month! if @every == 'day-of-month'
      validate_date_of_month! if @every == 'date-of-month'
    end

    def validate_day_of_month!
      raise ArgumentError, 'day_of_week is required for day-of-month' if @day_of_week.nil?
      raise ArgumentError, 'week_of_month must be an integer between 1 and 6' unless (1..6).include?(@week_of_month)
    end

    def validate_date_of_month!
      raise ArgumentError, 'date_of_month is required for date-of-month' if @date_of_month.nil?
    end
  end
end
