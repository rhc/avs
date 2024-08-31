# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage scan engine pools'
  command :scan_engine_pool do |c|
    c.desc 'List scan engine pools'
    c.flag :name, desc: 'Name'
    c.flag :id, desc: 'Unique ID', type: Integer

    c.command :list do |l|
      l.desc 'Filter scan engine pools by name (contains pattern)'

      l.action do |_global_options, options, _args|
        name = parent(options, :name)&.downcase
        App.api.fetch_scan_engine_pools do |scan_engine_pool|
          next if name && !scan_engine_pool.name.downcase.include?(name)

          puts scan_engine_pool.to_json
        end
      end
    end

    c.desc 'Get scan engine pool by id'
    c.command :get do |g|
      g.desc 'scan engine pool ID'
      g.action do |_global_options, options, _ags|
        id = parent(options)[:id]
        raise 'The scan engine pool id is a required parameter' if id.nil?

        scan_engine_pool = App.api.fetch_scan_engine_pool(id)
        puts scan_engine_pool.to_json
      end
    end
  end
end
