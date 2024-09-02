require 'minitest/autorun'
require 'minitest/spec'
require_relative '../../../lib/domain/site/model' # Adjust the path as necessary

describe Site do
  describe '.from_json' do
    it 'transforms keys correctly' do
      json_data = {
        'id' => 1,
        'name' => 'Test Site',
        'description' => 'A test site',
        'riskScore' => 75,
        'scanEngine' => 'Engine1',
        'scanTemplate' => 'Template1',
        'assets' => %w[asset1 asset2]
      }

      site = Site.from_json(json_data)

      assert_equal 1, site.id
      assert_equal 'Test Site', site.name
      assert_equal 'A test site', site.description
      assert_equal 75, site.risk_score
      assert_equal 'Engine1', site.scan_engine
      assert_equal 'Template1', site.scan_template
      assert_equal %w[asset1 asset2], site.assets
    end

    it 'handles snake_case keys' do
      json_data = {
        'id' => 2,
        'name' => 'Another Site',
        'risk_score' => 80,
        'scan_engine' => 'Engine2'
      }

      site = Site.from_json(json_data)

      assert_equal 2, site.id
      assert_equal 'Another Site', site.name
      assert_equal 80, site.risk_score
      assert_equal 'Engine2', site.scan_engine
    end

    it 'handles mixed case keys' do
      json_data = {
        'id' => 3,
        'name' => 'Mixed Case Site',
        'risk_score' => 90,
        'scanEngine' => 'Engine3',
        'scan_template' => 'Template3'
      }

      site = Site.from_json(json_data)

      assert_equal 3, site.id
      assert_equal 'Mixed Case Site', site.name
      assert_equal 90, site.risk_score
      assert_equal 'Engine3', site.scan_engine
      assert_equal 'Template3', site.scan_template
    end
  end
end

describe CmdbVulnerabilitySite do
  let(:site) { CmdbVulnerabilitySite.new }

  describe '#duration_in_hours' do
    it 'returns an integer, is non-negative, and does not exceed one week' do
      site.start_day = 'Monday'
      site.start_hour = 9
      site.end_day = 'Tuesday'
      site.end_hour = 17

      duration = site.duration_in_hours
      assert_kind_of Integer, duration
      refute duration.negative?, 'Duration should be non-negative'
      assert duration <= 24 * 7, 'Duration should not exceed one week'
    end

    it 'calculates duration for same day' do
      site.start_day = 'Monday'
      site.start_hour = 9
      site.end_day = 'Monday'
      site.end_hour = 17

      assert_equal 8, site.duration_in_hours
    end

    it 'calculates duration for overnight' do
      site.start_day = 'Monday'
      site.start_hour = 22
      site.end_day = 'Tuesday'
      site.end_hour = 6

      assert_equal 8, site.duration_in_hours
    end

    it 'calculates duration over weekend' do
      site.start_day = 'Friday'
      site.start_hour = 18
      site.end_day = 'Monday'
      site.end_hour = 6

      assert_equal 60, site.duration_in_hours
    end

    it 'calculates duration for full week' do
      site.start_day = 'Monday'
      site.start_hour = 0
      site.end_day = 'Sunday'
      site.end_hour = 23

      assert_equal 167, site.duration_in_hours
    end

    it 'returns zero for zero duration' do
      site.start_day = 'Monday'
      site.start_hour = 9
      site.end_day = 'Monday'
      site.end_hour = 9

      assert_equal 0, site.duration_in_hours
    end
  end
end
