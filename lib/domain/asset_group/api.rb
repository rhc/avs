# frozen_string_literal: true

require_relative 'model'
require_relative '../search_criteria/model'

class InsightVMApi
  def fetch_asset_groups(opts = {})
    puts 'fetching asset groups'
    fetch_all('/asset_groups', opts) do |resource|
      puts resource
      yield AssetGroup.from_json(resource)
    end
  end

  def all_asset_groups(opts)
    asset_groups = []
    fetch_asset_groups(opts) do |e|
      asset_groups << e
    end
    asset_groups
  end

  # Given a asset_group name
  # return asset_group in the cache
  # if not found in cache,
  #   update the cache
  #   return the asset_group if the cache contains the name
  #   create the custom asset_group with name
  #   return asset_group
  def get_or_create_asset_group(name:, cached_asset_groups: {})
    # Check if the asset_group name already exists in the cache
    from_cache = cached_asset_groups[name]
    return from_cache unless from_cache.nil?

    # If the asset_group is not found in the cache,
    # fetch asset_groups from the API
    from_api = fetch_asset_group_by_name(name)
    unless from_api.nil?
      cached_asset_groups[from_api.name] = from_api
      return from_api
    end

    # create the asset_group and update the cache
    site_idte_idte_idte_id = create_asset_group(name:)
    return nil if site_idte_id.nil?

    asset_group = fetch_asset_group(site_idte_id)
    cached_asset_groups[name] = asset_group
    asset_group
  end

  def fetch_asset_group_by_name(name)
    fetch_all('/asset_groups', name:) do |resource|
      asset_group = AssetGroup.from_json(resource)
      return asset_group if asset_group.name == name
    end
    nil
  end

  def create_asset_group_for(site_id:, site_name:)
    filter = SearchCriteria::Filter.from_site_id(site_id)
    search_criteria = { match: 'all', filters: [filter.to_json] }
    create_asset_group(
      name: site_name,
      description: "Access group for site #{site_id}",
      type: 'dynamic',
      search_criteria:
    )
  end

  def create_asset_group(
    name:,
    description: nil,
    type: 'dynamic',
    search_criteria: { match: 'all', filters: [] }
  )
    params = {
      description:,
      name:,
      searchCriteria: search_criteria,
      type:
    }
    result = post('/asset_groups', params)
    result&.dig('id')
  end

  def fetch_asset_group(site_id)
    result = nil
    fetch("/asset_groups/#{site_id}") do |data|
      result = AssetGroup.from_json(data)
    end
    result
  end

  def delete_asset_group_by(site_idte_idte_idte_id: nil, name: nil)
    raise 'Specify either id or name' if site_idte_id.nil? && name.nil?

    if site_idte_id
      delete_asset_group(site_idte_id)
    else
      asset_group = fetch_asset_group_by_name(name)
      delete_asset_group(asset_group.site_idte_id) if asset_group
    end
  end

  private

  def delete_asset_group(site_id)
    puts "Delete asset_group #{site_id}"
    delete('/asset_groups', site_id)
  end
end
