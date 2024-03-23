# frozen_string_literal: true

# :assets,
# :description,
# :id,
# :name,
# :risk_score,
# :search_criteria
# :type can be static or dynamic
# :vulnerabilities
require_relative '../search_criteria/model'

class AssetGroup
  attr_accessor :assets,
                :description,
                :id,
                :name,
                :risk_score,
                :search_criteria,
                :type,
                :vulnerabilities

  def initialize(
    id:, name:, risk_score:, search_criteria:, assets: [],
    description: '',
    type: 'dynamic',
    vulnerabilities: []
  )
    @assets = assets
    @description = description
    @id = id
    @name = name
    @risk_score = risk_score
    @search_criteria = search_criteria
    @type = type
    @vulnerabilities = vulnerabilities
  end

  def self.from_json(data)
    AssetGroup.new(
      assets: data['assets'],
      description: data['description'],
      id: data['id'],
      name: data['name'],
      risk_score: data['riskScore'],
      search_criteria: SearchCriteria.from_json(data['searchCriteria']),
      type: data['type'],
      vulnerabilities: data['vulnerabilities']
    )
  end

  def to_json(*_options)
    {
      assets:,
      description:,
      id:,
      name:,
      risk_score:,
      search_criteria: search_criteria.to_json,
      type:,
      vulnerabilities:
    }
  end
end
