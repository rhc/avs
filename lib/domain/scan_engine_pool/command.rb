# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage scan engine pools'
  command :scan_engine_pool do |c|
    c.desc 'List scan engine pools'
    c.command :list do |l|
      l.desc 'Filter scan engine pools by name (contains pattern)'
      l.flag [:filter]

      l.action do |_global_options, options, _args|
        filter = options[:filter]&.downcase
        App.api.fetch_scan_engine_pools do |site|
          puts site.to_json if filter.nil? || site.name.downcase.include?(filter)
        end
      end
    end

    c.desc 'Get scan engine pool by id'
    c.command :get do |g|
      g.desc 'scan engine pool ID'
      g.flag :id
      g.action do |_global_options, options, _args|
        site_idte_idte_idte_id = options[:id]
        credential = App.api.fetch_scan_engine_pool(site_idte_id)
        puts credential.to_json
      end
    end
  end
end
