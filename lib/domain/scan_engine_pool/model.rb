# frozen_string_literal: true

require_relative '../model'

class ScanEnginePool < Domain::Model
  attr_accessor :id,
                :name,
                :engines,
                :sites

  def to_json(*_options)
    { id:, name:, engines:, sites: }.to_json
  end
end
