# frozen_string_literal: true

require_relative '../model'

class SiteTarget < Domain::Model
  attr_accessor :site_id,
                :type,
                :included,
                :target,
                :scope

  def initialize(attributes = {})
    attributes[:type] = determine_target_type(attributes[:target]) if attributes[:type].nil? && attributes[:target]
    super(attributes)
  end

  def self.primary_key
    %w[site_id target type included scope]
  end

  def self.table_name
    'site_target'
  end

  private

  def determine_target_type(target)
    target.match?(/[a-zA-Z]/) ? 'host' : 'ip'
  end
end

class DiscoverySiteTarget < Domain::Model
  attr_accessor :site_id,
                :subnet,
                :start_ip,
                :end_ip

  def initialize(attributes = {})
    start_ip = attributes[:start_ip]
    end_ip = attributes[:end_ip]
    start_ip, end_ip = extract_ip_addresses(attributes[:subnet]) if start_ip.nil? || end_ip.nil?

    updated_attributes = attributes.merge(
      start_ip:,
      end_ip:
    )
    super(updated_attributes)
  end

  def self.primary_key
    %w[site_id subnet]
  end

  def self.table_name
    'country_discovery_site_target'
  end

  def extract_ip_addresses(range)
    if range.nil?
      raise ArgumentError,
            "Target cannot be nil. Please provide a valid IP address or range in the format 'start_ip - end_ip'."
    end

    min_ip = max_ip = range
    min_ip, max_ip = range.split(' - ') if range.include?(' - ')
    [IPAddr.new(min_ip), IPAddr.new(max_ip)]
  rescue IPAddr::InvalidAddressError => e
    raise ArgumentError, "Invalid IP address format found in #{range}: #{e.message}"
  end
end
