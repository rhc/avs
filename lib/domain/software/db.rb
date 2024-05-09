# frozen_string_literal: true

require 'csv'
require_relative 'model'
require_relative '../../app'

class Db
  @countries = nil

  def countries
    @countries ||= fetch_all_countries
  end

  private

  def fetch_all_countries
    App.db.all(Country)
  end
end
