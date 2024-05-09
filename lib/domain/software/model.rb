# frozen_string_literal: true

require_relative '../model'

class Country < Domain::Model
  attr_accessor :id, :name, :time_zone, :time_zone_r7

  def self.primary_key
    'code'
  end
end
