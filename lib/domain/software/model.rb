# frozen_string_literal: true

require_relative '../model'

class Software < Domain::Model
  attr_accessor :id,
                :name,
                :vendor,
                :family,
                :version,
                :software_class,
                :cpe
end
