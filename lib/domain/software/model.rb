# frozen_string_literal: true

require_relative '../model'

class Software < Domain::Model
  attr_accessor :id,
                :name,
                :vendor,
                :family,
                :version,
                :software_class,
                :cpe,
                :is_db,
                :db_type,
                :db_eos_date,
                :is_db_eos,
                :is_db_eos_upcoming_6_months,
                :is_db_eos_upcoming_6_12_months,
                :db_eos_source

  def db?
    is_db == '1'
  end
end

class CmdbEos < Domain::Model
  attr_accessor :product_id,
                :product_categorization_tier_1,
                :product_categorization_tier_2,
                :product_categorization_tier_3,
                :manufacturer,
                :product_name,
                :end_of_life_date,
                :end_of_support_date,
                :end_of_extended_support_date,
                :no_dates_reason

  def split_product_name(product_name)
    match = product_name.match(/^(.*?)(?:\s+Database Server)?(?:\s+v?(\d+\.\d+|\d+))?$/i)
    return product_name, nil unless match

    name = match[1].strip
    version = match[2]
    [name, version]
  end
end
