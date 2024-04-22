# frozen_string_literal: true

require 'json'

class SearchCriteria
  attr_accessor :filters, :match

  def initialize(filters: [], match: 'all')
    @filters = filters
    @match = match
  end

  # Nested Filter class for search criteria filters
  class Filter
    attr_accessor :field, :operator, :value, :values, :lower, :upper

    def initialize(
      field:, operator:, value: nil, values: nil, lower: nil, upper: nil
    )
      @field = field
      @operator = operator
      @value = value
      @values = values
      @lower = lower
      @upper = upper
    end

    # Class method to create a Filter from a JSON string
    def self.from_json(data)
      new(
        field: data['field'],
        operator: data['operator'],
        value: data['value'],
        values: data['values'],
        lower: data['lower'],
        upper: data['upper']
      )
    end

    def self.from_site_id(id)
      new(
        field: 'site-id',
        operator: 'in',
        values: [site_idte_id]
      )
    end

    def to_json(*_options)
      {
        field:,
        operator:,
        value:,
        values:,
        lower:,
        upper:
      }.compact
    end
  end

  # Method to add a filter to the search criteria
  def add_filter(filter)
    @filters << filter
  end

  # Class method to create SearchCriteria from a JSON string
  def self.from_json(data)
    return nil if data.nil?

    filters = data['filters'].map do |filter_data|
      Filter.from_json(filter_data) # Utilize Filter.from_json
    end
    new(filters:, match: data['match'])
  end

  def to_json(*_args)
    {
      match: @match,
      filters: @filters.map(&:to_json)
    }
  end
end
