# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  extend GLI::App

  desc 'Manage shared credentials'
  command :shared_credentials do |c|
    c.desc 'List credentials'
    c.command :list do |l|
      l.action do |_global_options, _options, _args|
        App.api.fetch_shared_credentials { |credential| puts credential }
      end
    end
    # c.default_command :help
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
