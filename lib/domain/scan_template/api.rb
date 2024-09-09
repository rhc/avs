#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'model'

class InsightVMApi
  def fetch_scan_templates
    return to_enum(__method__) unless block_given?

    fetch_all('/scan_templates') do |resource|
      yield ScanTemplate.from_json(resource)
    end
  end

  def get_vulnerability_scan_template_name(country_code)
    if country_code.downcase == 'za'
      ENV[:ZA_VULNERABILITY_SCAN_TEMPLATE_NAME]
    else
      ENV[:AR_VULNERABILITY_SCAN_TEMPLATE_NAME]
    end
  end

  def find_scan_template_by_name(name)
    fetch_scan_templates.find do |scan_template|
      scan_template.name.downcase == name.downcase
    end
  end

  def fetch_vulnerability_scan_template(country_code)
    name = get_vulnerability_scan_template_name(country_code)
    find_scan_template_by_name(name)
  end
end
