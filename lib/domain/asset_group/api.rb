# frozen_string_literal: true

require_relative 'model'

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
    id = create_asset_group(name:)
    return nil if id.nil?

    asset_group = fetch_asset_group(id)
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

  def create_asset_group(
    name:,
    description:, type: 'dynamic',
    search_criteria: {}
  )
    params = {
      description:,
      name:,
      searchCriteria: search_criteria,
      type:
    }
    result = post('/asset_groups', params)
    puts result
    result&.dig('id')
  end

  def fetch_asset_group(id)
    result = nil
    fetch("/asset_groups/#{id}") do |data|
      result = AssetGroup.from_json(data)
    end
    result
  end
end
