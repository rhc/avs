# frozen_string_literal: true

require 'csv'
require_relative 'model'
require_relative '../../app'

class Db
  def software_found_on_assets
    select(OperatingSystem, 'software_view')
  end
end
