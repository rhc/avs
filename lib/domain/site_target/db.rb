# frozen_string_literal: true

require 'csv'
require_relative 'model'

class Db
  def fetch_shared_credentials
    fetch_view('country_view') do |row|
      Country.from_csv(row)
    end
  end

  def save_country_discovery_site_targets(site_targets = [])
    site_targets.each do |target|
      next if target.type == 'host'

      discovery_site_target = DiscoverySiteTarget.new(
        site_id: site.id,
        subnet: target.target
      )
      upsert(discovery_site_target)
    end
  end

  def fetch_cyberark_shared_credentials(_country_code)
    credentials = fetch_shared_credentials
    credentials.select do |credential|
    end
  end
end
