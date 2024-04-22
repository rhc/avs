# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage shared credentials'
  command :shared_credential do |c|
    c.desc 'List credentials'
    c.command :list do |l|
      l.action do |_global_options, _options, _args|
        App.api.fetch_shared_credentials { |credential| puts credential }
      end
    end

    c.desc 'Get credential by id'
    c.command :get do |g|
      g.desc 'Credential unique id'
      g.flag :id
      g.action do |_global_options, options, _args|
        site_idte_idte_idte_id = options[:id]
        credential = App.api.fetch_shared_credential(site_idte_id)
        puts credential.to_json
      end
    end
    # c.desc 'Delete shared credentials'
    # c.command :delete do |d|
    #   d.desc 'Shared credential unique ID'
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
