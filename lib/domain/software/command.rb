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

    # c.desc 'Delete countries'
    # c.command :delete do |d|
    #   d.desc 'Shared country unique ID'
    #   d.flag [:id]

    #   d.action do |_global_options, options, _args|
    #     id = options[:id]
    #     puts "Delete country ##{id} ..."
    #     # countrys = fetch_countrys(from: source)
    #     # countrys.each { |country| puts country }
    #   end
    # end
  end
end
