# frozen_string_literal: true

require 'typhoeus'
require_relative 'model'

class App
  desc 'Manage assets'
  command :asset do |c|
    c.flag [:id], desc: 'Unique ID', type: Integer
    # c.desc 'List assets'
    # c.command :list do |l|
    #   l.desc 'UTR asset only'
    #   l.switch [:utr]

    #   l.action do |_global_options, options, _args|
    #     filter = options[GLI::Command::PARENT][:filter]&.downcase
    #     utr = options[:utr]
    #     App.api.fetch_assets do |asset|
    #       next if filter && !asset.name.downcase.include?(filter)
    #       next if utr && !asset.utr?

    #       puts asset.to_json
    #     end
    #   end
    # end

    c.desc 'List assets from cmdb'
    c.command :from_cmdb do |ldb|
      ldb.action do |_global_options, options, _args|
        filter = options[GLI::Command::PARENT][:filter]&.downcase
        App.db.fetch_cmdb_assets do |asset|
          next if filter && !asset.host_name.downcase.include?(filter)

          puts asset.to_json
        end
      end
    end

    c.desc 'Delete asset'
    c.command :delete do |d|
      d.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'Id is required' if id.nil?

        App.api.delete_asset(id)
      end
    end

    c.desc 'Delete printers'
    c.command :delete_printers do |dp|
      dp.action do |_global_options, _options, _args|
        asset_group = App.api.fetch_asset_group_by_name('Group Printers')
        assets = asset_group.assets
        raise 'The Group Printers asset group is currently empty.' if assets.zero?

        puts "#{assets} printers are going to be deleted."
        puts 'Fetching printer asset_ids ...'
        ids = App.api.fetch_asset_group_assets(asset_group.id)
        App.api.delete_assets(ids)
      end
    end

    c.desc 'Delete assets out of VM scope '
    c.command :delete_asset_out_of_vm_scope do |dg|
      dg.action do |_global_options, _options, _args|
        puts 'Fetching out of VM scope asset_ids ...'
        ids = App.db.fetch_out_of_vm_scope_asset_ids
        puts "#{ids.size} assets out of vm scope are going to be deleted."
        App.api.delete_assets(ids)
        # TODO: delete the asset in the asset table
      end
    end

    c.desc 'Delete ghosts'
    c.command :delete_ghosts do |dg|
      dg.action do |_global_options, _options, _args|
        puts 'Api call'
        asset_group = App.api.fetch_asset_group_by_name('Ghosts')
        assets = asset_group.assets
        unless assets.zero?
          puts "#{assets} ghosts are going to be deleted."
          puts 'Fetching ghost asset_ids ...'
          ids = App.api.fetch_asset_group_assets(asset_group.id)
          App.api.delete_assets(ids)
        end
      end
    end

    c.desc 'Delete asset group assets'
    c.command :delete_asset_group_assets do |dg|
      dg.flag :asset_group, desc: 'Asset group name'

      dg.action do |_global_options, options, _args|
        asset_group_name = options[:asset_group]
        raise 'The asset group name is required' if asset_group_name.nil?

        # asset_group = App.api.fetch_asset_group_by_name('Ghosts')
        asset_group = App.api.fetch_asset_group_by_name(asset_group_name)
        raise "#{asset_group_name} asset group does not exist." if asset_group.nil?

        puts "#{asset_group.assets} ghosts are going to be deleted."
        puts 'Fetching ghost asset_ids ...'
        ids = App.api.fetch_asset_group_assets(asset_group.id)
        App.api.delete_assets(ids)
      end
    end
  end
end
