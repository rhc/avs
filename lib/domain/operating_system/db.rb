# frozen_string_literal: true

require 'csv'
require_relative 'model'
require_relative '../../app'

class Db
  def operating_system_found_on_assets
    select(OperatingSystem, 'operating_system_view')
  end
end
