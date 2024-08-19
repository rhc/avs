# frozen_string_literal: true

require 'csv'
require_relative 'model'

class Db
  def fetch_utr_site_from_cmdb
    fetch_view('utr_site_view') do |row|
      CmdbDiscoverySite.from_csv(row)
    end
  end
end
