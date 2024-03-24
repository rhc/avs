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
        name = options[GLI::Command::PARENT][:name]
        type = options[GLI::Command::PARENT][:type]
        opts = { name:, type: }.compact
        App.api.fetch_asset_groups(opts) do |asset_group|
          puts asset_group.to_json
        end
      end
    end

    c.desc 'Get asset group by id'
    c.command :get do |g|
      g.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'You must specify the asset group Id' if id.nil?

        asset_group = App.api.fetch_asset_group(id)
        puts asset_group.to_json
      end
    end

    c.desc 'Create asset_group for a site'
    c.command :new do |n|
      n.flag ['site-name', :site_name],
             desc: 'Site', required: true

      n.action do |_global_options, options, _args|
        site_name = options[:site_name]

        site = App.api.fetch_site_by_name(site_name)
        raise "Cannot find the #{site_name} site" if site.nil?

        asset_group_id = App.api.create_asset_group_for site_id: site.id, site_name: site.name
        raise 'Asset group was not created' if asset_group_id.nil?
      end
    end

    c.desc 'Delete asset groups'
    c.command :delete do |d|
      d.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        name = options[GLI::Command::PARENT][:name]

        App.api.delete_asset_group_by(id:, name:)
      end
    end
  end
end
