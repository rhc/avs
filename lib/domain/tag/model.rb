# frozen_string_literal: true

# color can be 'default', 'blue', 'green', 'orange', 'red', 'purple'
# type can be location, owner, criticality, custom
# source can built-in, custom
class Tag
  attr_accessor :color,
                :created,
                :id,
                :name,
                :risk_modifier,
                :search_criteria,
                :source,
                :type

  def initialize(
    id:,
    name:,
    color: 'default',
    created: nil,
    risk_modifier: nil,
    search_criteria: nil,
    source: 'custom',
    type: 'custom'
  )
    @id = id
    @name = name
    @color = color
    @source = source
    @created = created
    @type = type
    @risk_modifier = risk_modifier
    @search_criteria = search_criteria
  end

  def self.from_json(data)
    Tag.new(
      color: data['color'],
      created: data['created'],
      id: data['id'],
      name: data['name'],
      risk_modifier: data['riskModifier'],
      search_criteria: data['searchCriteria'],
      type: data['type']
    )
  end

  def to_json(*_options)
    {
      color:,
      created:,
      id:,
      name:,
      risk_modifier:,
      search_criteria:,
      type:
    }
  end
end
