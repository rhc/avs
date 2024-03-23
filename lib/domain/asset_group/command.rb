# frozen_string_literal: true

require_relative 'model'
# require_relative '../../service/mail'

class App
  desc 'Manage asset groups'
  command :asset_group do |c|
    c.desc 'name'
    c.flag [:name]
    c.desc 'type (static or dynamic)'
    c.flag [:type]
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
      n.desc 'Site'
      n.flag ['site-name', :site_name]

      n.action do |_global_options, options, _args|
        site_name = options[:site_name]
        if site_name.nil?
          puts 'Cannot create a asset_group without a valid name.'
          exit
        end
        asset_group_id = App.api.create_asset_group_for_site(name: site_name)
        puts 'asset_group was not created' if asset_group_id.nil?
      end
    end

    c.desc 'Delete asset groups'
    c.command :delete do |d|
      d.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        name = options[GLI::Command::PARENT][:name]
        raise 'You must specify the access group id or name to be deleted' if id.nil? && name.nil?

        App.api.delete_asset_group(id) if id

        App.api.delete_asset_group_by_name(name) if name
      end
    end
  end
end
