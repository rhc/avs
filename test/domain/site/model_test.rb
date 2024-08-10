require 'minitest/autorun'
require_relative '../../../lib/domain/site/model' # Adjust the path as necessary

class TestSite < Minitest::Test
  def test_from_json_transforms_keys_correctly
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

  def test_from_json_handles_snake_case_keys
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

  def test_from_json_handles_mixed_case_keys
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
