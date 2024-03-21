# frozen_string_literal: true

require_relative 'model'

class InsightVMApi
  def fetch_tags
    fetch_all('/tags') do |resource|
      yield Tag.from_json(resource)
    end
  end

  def all_tags
    tags = []
    fetch_tags do |e|
      tags << e
    end
    tags
  end

  # Given a tag name
  # return tag in the cache
  # if not found in cache,
  #   update the cache
  #   return the tag if the cache contains the name
  #   create the custom tag with name
  #   return tag
  def get_or_create_tag(name:, cached_tags: {})
    # Check if the tag name already exists in the cache
    from_cache = cached_tags[name]
    return from_cache unless from_cache.nil?

    # If the tag is not found in the cache,
    # fetch tags from the API
    from_api = fetch_tag_by_name(name)
    unless from_api.nil?
      cached_tags[from_api.name] = from_api
      return from_api
    end

    # create the tag and update the cache
    id = create_tag(name:)
    return nil if id.nil?

    tag = fetch_tag(id)
    cached_tags[name] = tag
    tag
  end

  def fetch_tag_by_name(name)
    fetch_all('/tags', name:) do |resource|
      tag = Tag.from_json(resource)
      return tag if tag.name == name
    end
    nil
  end

  def create_tag(
    name:,
    color: 'default',
    risk_modifier: 1.0,
    type: 'custom',
    source: 'custom'
  )
    puts "type #{type}"
    puts "color #{color}"
    params = {
      color:,
      name:,
      riskModifier: risk_modifier,
      type:,
      source:
    }
    result = post('/tags', params)
    puts result
    result&.dig('id')
  end

  def fetch_tag(id)
    result = nil
    fetch("/tags/#{id}") do |data|
      result = Tag.from_json(data)
    end
    result
  end
end
