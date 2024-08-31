# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage scan engine pools'
  command :scan_engine_pool do |c|
    c.desc 'List scan engine pools'
    c.command :list do |l|
      l.desc 'Filter scan engine pools by name (contains pattern)'
      l.flag [:name]

      l.action do |_global_options, options, _args|
        name = options[:name]&.downcase
        App.api.fetch_scan_engine_pools do |scan_engine_pool|
          puts scan_engine_pool.to_json if name.nil? || scan_engine_pool.name.downcase.include?(name)
        end
      end
    end

    c.desc 'Get scan engine pool by id'
    c.command :get do |g|
      g.desc 'scan engine pool ID'
      g.flag :id
      g.action do |_global_options, options, _args|
        id = options[:id]
        raise 'The scan engine pool id is a required parameter' if id.nil?

        scan_engine_pool = App.api.fetch_scan_engine_pool(id)
        puts scan_engine_pool.to_json
      end
    end
  end
end
