# frozen_string_literal: true

require_relative '../model'

class SiteTarget < Domain::Model
  attr_accessor :site_id, :type, :included, :target, :scope

  def self.primary_key
    'id'
  end

  def self.table_name
    'site_target'
  end
end
