# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage shared credentials'
  command :shared_credential do |c|
    c.flag [:id], desc: 'Shared credential unique ID', type: Integer
    c.flag [:name], desc: 'name'

    c.desc 'List credentials'
    c.command :list do |l|
      l.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        name = options[GLI::Command::PARENT][:name]
        App.api.fetch_shared_credentials do |credential|
          next if id && credential.id != id
          next if name && !credential.name.downcase.include?(name.downcase)

          puts credential
        end
      end
    end

    # c.desc 'Get credential by id'
    # c.command :get do |g|
    #   g.desc 'Credential unique id'
    #   g.action do |_global_options, options, _args|
    #     site_id = options[:id]
    #     credential = App.api.fetch_shared_credential(site_id)
    #     puts credential.to_json
    #   end
    # end

    c.desc 'List UTR sites from shared credential'
    c.command :utr_site_list do |usl|
      usl.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'The shared credential ID is required' if id.nil?

        credential = App.api.fetch_shared_credential(id)
        raise "Shared credential id #{id} was not found." if credential.nil?

        puts 'Fetching UTR sites ...'
        utr_sites = App.api.fetch_utr_sites
        sites = App.api.list_shared_credential_utr_sites(credential, utr_sites)
        sites.each do |site|
          puts [site.id, site.name].join ','
        end
      end
    end

    c.desc 'Remove UTR sites from shared credential'
    c.command :utr_site_remove do |d|
      d.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'The shared credential ID is required' if id.nil?

        credential = App.api.fetch_shared_credential(id)
        raise "Shared credential id #{id} was not found." if credential.nil?

        puts 'Fetching UTR sites ...'
        utr_sites = App.api.fetch_utr_sites
        App.api.remove_shared_credential_utr_sites(credential, utr_sites)
      end
    end
  end
end
