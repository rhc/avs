# frozen_string_literal: true

require_relative 'model'
# require_relative '../../service/mail'

class App
  desc 'Manage asset groups'
  command :asset_group do |c|
    c.desc 'List asset groups'
    c.command :list do |l|
      l.desc 'name'
      l.flag [:name]
      l.desc 'type (static or dynamic)'
      l.flag [:type]

      # TODO: l.desc 'Status (all|up|down)'
      l.action do |_global_options, options, _args|
        name = options[:name]
        type = options[:type]
        opts = { name:, type: }.compact
        App.api.fetch_asset_groups(opts) do |asset_group|
          puts asset_group.to_json
        end
      end
    end

    c.desc 'Get asset group by id'
    c.command :get do |g|
      g.desc 'asset group ID'
      g.flag :id
      g.action do |_global_options, options, _args|
        id = options[:id]
        credential = App.api.fetch_shared_credential(id)
        puts credential.to_json
      end
    end

    # c.desc 'Delete asset groups'
    # c.command :delete do |d|
    #   d.desc 'asset group unique ID'
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
