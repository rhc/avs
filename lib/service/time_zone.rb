# frozen_string_literal: true

require 'active_support/all'

module Service
  module TimeZone
    ZONES = {
      'ao' => 'Africa/Casablanca', # Angola
      'bw' => 'Africa/Harare', # Botswana
      'cd' => 'Africa/Casablanca', # Democratic Republic of the Congo
      'sz' => 'Africa/Harare', # Eswatini
      'gh' => 'Atlantic/Azores', # Ghana
      'intl' => 'Atlantic/Azores', # International (Generic UTC)
      'ci' => 'Atlantic/Azores', # Ivory Coast
      'je' => 'Europe/London',          # Jersey
      'ke' => 'Africa/Nairobi',         # Kenya
      'ls' => 'Africa/Harare',          # Maseru Lesotho
      'mw' => 'Africa/Harare', # Malawi
      'mu' => 'Asia/Muscat', # Mauritius
      'mz' => 'Africa/Harare', # Mozambique
      'na' => 'Africa/Harare', # Namibia
      'ng' => 'Africa/Casablanca', # Nigeria
      'za' => 'Africa/Harare', # South Africa
      'tz' => 'Africa/Nairobi', # Tanzania
      'ug' => 'Africa/Nairobi', # Uganda
      'zm' => 'Africa/Nairobi', # Zambia
      'zw' => 'Africa/Harare', # Zimbabwe
      'us' => 'America/Los_Angeles'
    }

    # Ensure the time zone data is loaded
    ActiveSupport::TimeZone.all

    # return the local time in the country
    # return nil if country_code is not found in [ZONES]
    def self.iso8601(country_code:, local_time:)
      zone_id = ZONES[country_code] || 'GMT'
      iso8601_with_zone_id(zone_id, local_time)
    end

    # Format the time to ISO 8601 with the zone identifier
    # (example: "America/New_York")
    def self.iso8601_with_zone_id(zone_id, local_time)
      zone = ActiveSupport::TimeZone[zone_id]
      datetime = zone.local(local_time.year, local_time.month, local_time.day, local_time.hour, local_time.minute)
      datetime.iso8601 + "[#{zone.name}]"
    end

    def self.duration_in_hours(start_day, start_hour, end_day, end_hour)
      start_index = Date::DAYNAMES.index(start_day.capitalize)
      end_index = Date::DAYNAMES.index(end_day.capitalize)

      raise ArgumentError, 'Invalid day provided' if start_index.nil? || end_index.nil?

      end_index += 7 if start_index > end_index

      start_hours = start_index * 24 + start_hour.to_i
      end_hours = end_index * 24 + end_hour.to_i
      end_hours - start_hours
    end
  end

  module DateTime
    # return start_date if start_datetime day of week == day_of_week
    # return the day after start_date with the same day_of_week
    def self.closest_day_of_week(start_datetime, day_of_week)
      target_index = Date::DAYNAMES.index(day_of_week.capitalize)
      start_index = start_datetime.wday
      difference = target_index - start_index
      return start_datetime if difference.zero?

      delta = (difference + 7) % 7
      start_datetime + delta
    end
  end
end
