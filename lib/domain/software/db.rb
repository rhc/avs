# frozen_string_literal: true

require 'csv'
require_relative 'model'
require_relative '../../app'

class Db
  def software_found_on_assets
    select(Software, 'software_view')
  end

  def softwares(type)
    list = select(Software, 'software_view')
    return list if type == 'all'

    return list.select(&:db?) if type == 'db'

    list.reject(&:db?)
  end

  def software_database; end

  def product_in_cmdb_eos
    all(CmdbEos)
  end

  def save_microsoft_product_lifecycle(models)
    bulk_copy(models)
  end
end
