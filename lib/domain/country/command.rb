# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage countries'
  command :country do |c|
    c.desc 'List countries'
    c.command :list do |l|
      l.action do |_global_options, _options, _args|
        App.db.all(Country).each do |country|
          puts country
        end
      end
    end

    # c.desc 'Delete countries'
    # c.command :delete do |d|
    #   d.desc 'Shared country unique ID'
    #   d.flag [:id]

    #   d.action do |_global_options, options, _args|
    #     id = options[:id]
    #     puts "Delete country ##{id} ..."
    #     # countrys = fetch_countrys(from: source)
    #     # countrys.each { |country| puts country }
    #   end
    # end
  end
end
