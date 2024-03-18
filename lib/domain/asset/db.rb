# frozen_string_literal: true

require 'csv'

class Db
  def fetch_cmdb_assets
    fetch_view('utr_asset_view') do |row|
      CmdbAsset.from_csv(row)
    end
  end
end
