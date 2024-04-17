require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../../lib/service/time_zone' # Update the path as necessary

Minitest::Reporters.use!

class TimeZoneTest < Minitest::Test
  def setup
    # Setting up any necessary data or state before each test
    @local_time = DateTime.new(2023, 10, 5, 20, 30, 0) # local time
  end

  def test_iso8601_with_valid_country_code
    result = Service::TimeZone.iso8601(country_code: 'cd', local_time: @local_time)
    assert_includes result, '2023-10-05T20:30:00+01:00[Africa/Kinshasa]'
  end

  def test_iso8601_with_invalid_country_code
    result = Service::TimeZone.iso8601(country_code: 'xyz', local_time: @local_time)
    assert_includes result, 'GMT'
  end

  def test_iso8601_with_negative_offset
    result = Service::TimeZone.iso8601(country_code: 'us', local_time: @local_time)
    assert_includes result, '2023-10-05T20:30:00-07:00[America/Los_Angeles]'
  end
end
