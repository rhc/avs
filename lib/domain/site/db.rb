# frozen_string_literal: true

require 'csv'
require_relative '../site_target/model'
require_relative 'model'

class Db
  def fetch_utr_site_from_cmdb
    fetch_view('utr_site_view') do |row|
      CmdbSite.from_csv(row)
    end
  end

  def save_country_discovery_site(site)
    upsert(site)
    site.targets.each do |target|
      next if target.type == 'host'

      site_target = DiscoverySiteTarget.new(
        site_id: site.id,
        subnet: target.target
      )
      upsert(site_target)
    end
  end
end
