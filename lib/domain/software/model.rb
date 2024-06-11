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

class MicrosoftProductLifecycle < Domain::Model
  attr_accessor :id,
                :product,
                :edition,
                :release,
                :support_policy,
                :start_date,
                :main_stream_date,
                :extended_end_date,
                :retirement_date,
                :release_start_date,
                :release_end_date,
                :docs_url

  def initialize(attributes = {})
    remapped_attributes = attributes.transform_keys do |key|
      case key
      when 'Product' then 'product'
      when 'Edition' then 'edition'
      when 'Release' then 'release'
      when 'SupportPolicy' then 'support_policy'
      when 'StartDate' then 'start_date'
      when 'MainStreamDate' then 'main_stream_date'
      when 'ExtendedEndDate' then 'extended_end_date'
      when 'RetirementDate' then 'retirement_date'
      when 'ReleaseStartDate' then 'release_start_date'
      when 'ReleaseEndDate' then 'release_end_date'
      when 'DocsUrl' then 'docs_url'
      else key
      end
    end
    product = remapped_attributes['product']
    edition = remapped_attributes['edition']
    release = remapped_attributes['release']
    remapped_attributes['id'] = [product, edition, release]
                                .compact
                                .select { |attr| attr.strip.length > 0 }
                                .join(':')
    super(remapped_attributes)
  end
end
