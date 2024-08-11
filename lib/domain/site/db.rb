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

  def fetch_country_discovery_sites_from_db
    fetch_view('country_discovery_site_view') do |row|
      yield CountryDiscoverySite.from_csv(row)
    end
  end

  def save_country_discovery_site(site)
    upsert(site)
  end
end
