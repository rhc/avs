# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage scan engines'
  command :scan_engines do |c|
    c.desc 'List credentials'
    c.command :list do |l|
      l.action do |_global_options, _options, _args|
        App.api.fetch_scan_engines { |engine| puts engine.to_json }
      end
    end

    c.desc 'Get scan engine by id'
    c.command :get do |g|
      g.desc 'Scan engine ID'
      g.flag :id
      g.action do |_global_options, options, _args|
        id = options[:id]
        credential = App.api.fetch_shared_credential(id)
        puts credential.to_json
      end
    end
    # c.desc 'Delete scan engines'
    # c.command :delete do |d|
    #   d.desc 'scan engine unique ID'
    #   d.flag [:id]

    #   d.action do |_global_options, options, _args|
    #     id = options[:id]
    #     puts "Delete credential ##{id} ..."
    #     # credentials = fetch_credentials(from: source)
    #     # credentials.each { |credential| puts credential }
    #   end
    # end
  end
end
