# frozen_string_literal: true

require 'csv'

class Db
  def fetch_cmdb_assets
    fetch_view('utr_asset_view') do |row|
      CmdbAsset.from_csv(row)
    end
  end

  def fetch_out_of_vm_scope_asset_ids
    ids = []
    fetch_view('asset_out_of_vm_scope_view') do |row|
      ids << row[:id].to_i
    end
    ids
  end
end
