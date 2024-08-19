# frozen_string_literal: true

require 'csv'
require_relative '../site_target/model'
require_relative 'model'

class Db
  def fetch_cmdb_discovery_sites
    fetch_view(CmdbDiscoverySite.view) do |row|
      yield CmdbDiscoverySite.from_csv(row)
    end
  end

  def fetch_country_discovery_sites_from_db
    fetch_view(CountryDiscoverySite.view) do |row|
      yield CountryDiscoverySite.from_csv(row)
    end
  end

  def save_country_discovery_site(site)
    upsert(site)
  end
end
