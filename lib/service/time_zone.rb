# frozen_string_literal: true

require 'active_support/all'

module Service
  module TimeZone
    ZONES = {
      'ao' => 'Africa/Luanda',          # Angola
      'bw' => 'Africa/Gaborone',        # Botswana
      'cd' => 'Africa/Kinshasa',        # Democratic Republic of the Congo
      'sz' => 'Africa/Mbabane',         # Eswatini
      'gh' => 'Africa/Accra',           # Ghana
      'intl' => 'Etc/UTC',              # International (Generic UTC)
      'ci' => 'Africa/Abidjan',         # Ivory Coast
      'je' => 'Europe/Jersey',          # Jersey
      'ke' => 'Africa/Nairobi',         # Kenya
      'ls' => 'Africa/Maseru',          # Lesotho
      'mw' => 'Africa/Blantyre',        # Malawi
      'mu' => 'Indian/Mauritius',       # Mauritius
      'mz' => 'Africa/Maputo',          # Mozambique
      'na' => 'Africa/Windhoek',        # Namibia
      'ng' => 'Africa/Lagos',           # Nigeria
      'za' => 'Africa/Johannesburg',    # South Africa
      'tz' => 'Africa/Dar_es_Salaam',   # Tanzania
      'ug' => 'Africa/Kampala',         # Uganda
      'zm' => 'Africa/Lusaka',          # Zambia
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
  end
end
