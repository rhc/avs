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
        credentials = App.fetch_credentials
        credentials.each { |credential| puts credential }
      end
    end
    # c.default_command :help
    c.desc 'Delete shared credentials'
    c.command :delete do |d|
      d.desc 'Specify source to fetch credentials form'
      d.default_value 'api'
      d.flag [:id]

      d.action do |_global_options, options, _args|
        id = options[:id]
        puts "Fetch credentials from  #{id} ..."
        # credentials = fetch_credentials(from: source)
        # credentials.each { |credential| puts credential }
      end
    end
  end

  def self.fetch_credentials()
    credentials = api.fetch_credentials
  end
end
