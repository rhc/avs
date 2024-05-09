#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'model'
require_relative '../../app'

class InsightVMApi
  def find_by_country_code(cc)
    App.db.countries.find { |country| country.code == cc }
  end
end
