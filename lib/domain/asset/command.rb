# frozen_string_literal: true

require_relative 'model'

class App
  desc 'Manage assets'
  command :asset do |c|
    c.desc 'Filter assets by host name'
    c.flag [:filter]
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
    c.desc 'Get asset by id'
    c.command :get do |g|
      g.desc 'ID'
      g.flag :id
      g.action do |_global_options, options, _args|
        site_idte_idte_idte_id = options[:id]
        credential = App.api.fetch_shared_credential(site_idte_id)
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
