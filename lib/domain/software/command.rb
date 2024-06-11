# frozen_string_literal: true

require_relative 'model'

class App
  desc 'Manage softwares'
  command :software do |c|
    c.desc 'List softwares'
    c.command :list do |l|
      l.flag :type, desc: 'Filter software by type (all|db|no-db)', default_value: 'all'
      l.action do |_global_options, options, _args|
        type = options[:type]
        puts "type: #{type}"
        App.db.softwares(type).each do |software|
          puts software
        end
      end
    end

    c.desc 'List products from CMDB EOS'
    c.command :cmdb_eos_products do |l|
      l.action do |_global_options, _options, _args|
        App.db.product_in_cmdb_eos.each do |software|
          puts software
        end
      end
    end

    c.desc 'Upload Microsoft product lifecycle'
    c.command :upload_microsoft_product_lifecycle do |l|
      l.flag :spreadsheet, desc: 'Excel spreasheet'
      l.action do |_global_options, options, _args|
        spreadsheet = options[:spreadsheet]
        raise 'You must provide the /path/to/spreadsheet.xlsx' if spreadsheet.nil?

        products = App.api.fetch_microsoft_product_lifecycle(spreadsheet, tabsheet_name: 'lifecycle_data')
        App.db.save_microsoft_product_lifecycle(products)
      end
    end
  end
end
