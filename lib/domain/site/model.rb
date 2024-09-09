# frozen_string_literal: true

require_relative '../../service/time_zone'
require_relative '../model'

# The Site class represents a site in the system, containing various attributes
# and methods related to site management and identification.
#
class Site < Domain::Model
  UTR_PATTERN = /:UTR\d{5}$/
  NETWORK_DISCOVERY_PATTERN = /Network Discovery Scan/
  CMDB_VULNERABILITY_PATTERN = /Vulnerability Scan/

  attr_accessor :id,
                :name,
                :description,
                :risk_score,
                :scan_engine,
                :scan_template,
                :assets

  def to_s
    [id, name, scan_engine, scan_template].join ','
  end

  def scan_template_id
    return nil unless utr?

    if name.include?(':za:')
      # settings[:za_full_audit]
      '_-sa-ca-_100_-_-pps_min-2000-_-max-15000-_--_-full-audit-without-web-spider'
    else
      # settings[:ar_full_audit]
      '_-angola-ca-_100_-_-pps_min-450-_-max-450-_--_-full-audit-without-web-spider-copy'
    end
  end

  # returns the time_zone
  # from the 2-letter country code
  def time_zone(country_code)
    # {'a'}
  end

  def country_code
    return nil unless utr?

    matches = name.match(/^:(.*?):/)
    matches ? matches[1] : nil
  end

  def utr_digits
    digits = name.match(UTR_PATTERN)
    digits ? digits[1].to_i : 0
  end

  # returns true if the site ends with :UTR followed by 5 digits
  def utr?
    name =~ UTR_PATTERN
  end

  # return true if the site name contains Network Discovery Scan (2024)
  def country_discovery?
    name =~ NETWORK_DISCOVERY_PATTERN
  end

  def cmdb_discovery?
    utr?
  end

  # return true if the site name
  # contains only 2 colons (:)
  # and it is not a cmdb_discovery?
  def cmdb_vulnerability?
    return false if cmdb_discovery?

    name =~ CMDB_VULNERABILITY_PATTERN && name.count(':') == 2
  end
end

# CmdbDiscoverySite represents a site from the Configuration Management Database (CMDB).
# It contains various attributes related to the site's location, business context,
# and network information.
#
class CmdbDiscoverySite < Domain::Model
  attr_accessor :name,
                :country,
                :country_code,
                :business_unit,
                :sub_area,
                :application,
                :utr,
                :network_zone,
                :scan_engine,
                :scan_template,
                :targets,
                :country_discovery_site_id,
                :bu, # business_unit short name
                :sa # sub_area short name

  def self.view
    'cmdb_discovery_site_view'
  end

  def to_s
    [name, country_code, network, business_unit, sub_area, application, utr].join ','
  end

  def tag_names
    app_utr = "#{application}-#{utr}"
    [country_code, network_zone, bu, sa, app_utr]
  end

  def included_targets
    targets.split(/\s+/)
  end
end

# CmdbVulnerabilitySite represents a site from the Configuration Management Database (CMDB).
# It contains various attributes related to the site's location, business context,
# and network information.
#
class CmdbVulnerabilitySite < Domain::Model
  attr_accessor :country_code,
                :network_zone,
                :business_unit_code,
                :assets,
                :start_day,
                :start_hour,
                :end_day,
                :engine_pool,
                :scan_engine_pool_id
                :end_hour


  def name
    prefix = [country_code, network_zone, business_unit_code].join ':'
    suffix = 'Vulnerability Scan'
    "#{prefix} #{suffix}"
  end

  def asset_group_name
    [country_code, network_zone, business_unit_code].join(':')
  end

  def duration_in_hours
    Service::TimeZone.duration_in_hours(start_day, start_hour, end_day, end_hour)
  end

  def self.view
    'cmdb_vulnerability_site_view'
  end
end

class CountryDiscoverySite < Domain::Model
  attr_accessor :id,
                :name,
                :country,
                :network_zone,
                :scan_engine,
                :scan_template

  def self.table_name
    'country_discovery_site'
  end

  def initialize(attributes = {})
    attributes[:country] ||= self.class.country(attributes[:name]) if attributes[:name]
    attributes[:network_zone] ||= self.class.network_zone(attributes[:name]) if attributes[:name]
    super(attributes)
  end

  def self.network_zone(site_name)
    if site_name.include?('DMZ')
      'dmz'
    else
      'core'
    end
  end

  # Extract the country between the start of the site name
  # end the first occurence of the words [DMZ,Core,Data Centre]
  def self.country(site_name)
    network_zone_pattern = /DMZ|Core|Data Centre/
    parts = site_name.split(network_zone_pattern)
    if parts.length > 1
      parts.first.strip
    else
      'Unknown'
    end
  end
end
