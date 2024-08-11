# frozen_string_literal: true

require_relative '../model'

# The Site class represents a site in the system, containing various attributes
# and methods related to site management and identification.
#
# This class inherits from Domain::Model and includes functionality for
# handling UTR (Unique Tax Reference) sites, network discovery scans,
# and various site-specific operations.
#
# Attributes:
#   id: The unique identifier for the site
#   name: The name of the site
#   description: A description of the site
#   risk_score: The risk score associated with the site
#   scan_engine: The scan engine used for this site
#   scan_template: The scan template applied to this site
#   assets: The assets associated with this site
#
# Class Constants:
#   UTR_PATTERN: Regular expression pattern for identifying UTR in site names
#   NETWORK_DISCOVERY_PATTERN: Pattern for identifying network discovery scans
#
# Key Methods:
#   scan_template_id: Determines the appropriate scan template ID based on site characteristics
#   country_code: Extracts the country code from the site name
#   utr?: Checks if the site is a UTR site
#   country_discovery?: Checks if the site is a network discovery scan site

class Site < Domain::Model
  UTR_PATTERN = /:UTR\d{5}$/
  NETWORK_DISCOVERY_PATTERN = /Network Discovery Scan/

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
end

# CmdbSite represents a site from the Configuration Management Database (CMDB).
# It contains various attributes related to the site's location, business context,
# and network information.
#
# Attributes:
#   name: The name of the site
#   country_code: The two-letter country code where the site is located
#   business_unit: The business unit associated with the site
#   sub_area: The sub-area within the business unit
#   application: The application running at the site
#   utr: The UTR (Unique Tax Reference) associated with the site
#   network_zone: The network zone for the site
#
# This class also provides a method to create a CmdbSite object from a CSV row
# and a string representation of the object.

class CmdbSite < Domain::Model
  attr_accessor :name,
                :country_code,
                :business_unit,
                :sub_area,
                :application,
                :utr,
                :network_zone

  def self.from_csv(row)
    CmdbSite.new(
      name: row[:site],
      country_code: row[:country_code],
      business_unit: row[:business_unit],
      sub_area: row[:sub_area],
      application: row[:application],
      utr: row[:utr],
      network_zone: row[:network]
    )
  end

  def to_s
    [name, country_code, network, business_unit, sub_area, application, utr].join ','
  end
end

class DiscoverySite < Domain::Model
  attr_accessor :id,
                :name,
                :country,
                :targets,
                :network_zone

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

  def target_names
    targets.map(&:target)
  end
end
