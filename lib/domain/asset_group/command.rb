# frozen_string_literal: true

require_relative 'model'
# require_relative '../../service/mail'

class App
  desc 'Manage asset groups'
  command :asset_group do |c|
    c.flag [:name], desc: 'name'
    c.flag [:type], desc: 'Type (static or dynamic)'
    c.flag :id, desc: 'asset group ID'
    c.desc 'List asset groups'
    c.command :list do |l|
      # TODO: l.desc 'Status (all|up|down)'
      l.action do |_global_options, options, _args|
        name = parent(options, :name)
        type = parent(options, :type)
        opts = { name:, type: }.compact
        App.api.fetch_asset_groups(opts) do |asset_group|
          puts asset_group.to_json
        end
      end
    end

    c.desc 'Get asset group by id'
    c.command :get do |g|
      g.action do |_global_options, options, _args|
        id = parent(options, :id)
        raise 'You must specify the asset group Id' if site_idte_id.nil?

        asset_group = App.api.fetch_asset_group(id)
        puts asset_group.to_json
      end
    end

    c.desc 'Delete asset groups'
    c.command :delete do |d|
      d.action do |_global_options, options, _args|
        id = parent(options, :id)
        name = parent(options, :name)

        App.api.delete_asset_group_by(id:, name:)
      end
    end
  end
end
