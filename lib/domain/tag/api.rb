# frozen_string_literal: true

require_relative 'model'

class InsightVMApi
  def fetch_tags
    return to_enum(__method__) unless block_given?

    fetch_all('/tags') do |resource|
      yield Tag.from_json(resource)
    end
  end

  # Given a tag name
  # return tag in the cache
  # if not found in cache,
  #   update the cache
  #   return the tag if the cache contains the name
  #   create the custom tag with name
  #   return tag
  def upsert_tag(name:)
    @cached_tags ||= initialize_cached_tags

    from_cache = @cached_tags[name]
    return from_cache unless from_cache.nil?

    from_api = find_tag_by_name(name)
    unless from_api.nil?
      @cached_tags[from_api.name] = from_api
      return from_api
    end

    id = create_tag(name:)
    return nil if id.nil?

    tag = fetch_tag(id)
    @cached_tags[name] = tag
    tag
  end

  def find_tag_by_name(name)
    fetch_all('/tags', { name: }) do |resource|
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
    params = {
      color:,
      name:,
      riskModifier: risk_modifier,
      type:,
      source:
    }
    result = post('/tags', params)
    result&.dig('id')
  end

  def fetch_tag(site_id)
    result = nil
    fetch("/tags/#{site_id}") do |data|
      result = Tag.from_json(data)
    end
    result
  end

  def add_tags_to_site(site_id:, tag_ids:)
    tag_ids.each do |tag_id|
      put("/sites/#{site_id}/tags/#{tag_id}", nil)
    end
  end

  private

  def initialize_cached_tags
    cache = {}
    fetch_tags.each do |tag|
      cache[tag.name] = tag
    end
    cache
  end
end
