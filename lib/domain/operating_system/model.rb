# frozen_string_literal: true

require_relative '../model'

class OperatingSystem < Domain::Model
  attr_accessor :id,
                :name,
                :asset_type,
                :description,
                :vendor,
                :family,
                :version,
                :architecture,
                :system,
                :cpe

  def self.primary_key
    'id'
  end
end
