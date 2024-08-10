# frozen_string_literal: true

require 'typhoeus'
require_relative '../country/model'
require_relative 'model'

class InsightVMApi
  def delete_asset(id)
    raise 'Cannot delete asset without ID' if id.nil?

    delete('/assets', id)
  end

  # Use Typhoeus for concurrency
  def delete_assets(ids = [], threads = nil)
    return if ids.empty?

    threads ||= ids.size**0.5
    size = ids.size / threads
    batches = ids.each_slice(size)
    hydra = Typhoeus::Hydra.new(max_concurrency: threads)
    batches.each do |batch|
      batch.each do |id|
        request = create_delete_request(id)
        hydra.queue(request)
      end
      # Run the queued batch of requests
      hydra.run
    end

    # TODO: give the number of deleted assets
    puts 'All assets in the group have been successfully deleted.'
  end

  def fetch_site_assets(site_id:)
    fetch_all("/sites/#{site_id}/assets") do |resource|
      yield Asset.from_json(resource)
    end
  end

  def delete_site_assets(site_id:)
    asset_ids = []
    fetch_site_assets(site_id:) do |asset|
      puts "Asset ##{asset.id} #{asset.ip} #{asset.host_name}"
      asset_ids << asset.id
    end
    delete_assets(asset_ids)
  end

  private

  # Creates a Typhoeus request for deleting an asset
  def create_delete_request(asset_id)
    Typhoeus::Request.new(
      "#{base_url}/assets/#{asset_id}",
      method: :delete,
      headers: { Authorization: base_auth },
      ssl_verifypeer: false
    ).tap do |request|
      request.on_complete do |response|
        if response.success?
          puts "Successfully deleted asset #{asset_id}"
        elsif response.timed_out?
          puts "Timeout while trying to delete asset #{asset_id}"
        elsif response.code.zero?
          puts "HTTP request failed: #{response.return_message}"
        else
          puts "Delete asset #{asset_id} failed: #{response.code}"
        end
      end
    end
  end
end
