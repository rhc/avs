# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage scan engines'
  command :scan_engine do |c|
    c.desc 'List scan engines'
    c.command :list do |l|
      l.desc 'Filter scan engines by name (contains pattern)'
      l.flag [:filter]

      l.desc 'Only display scan engines that are currently up'
      l.switch [:up]

      # TODO: l.desc 'Status (all|up|down)'
      l.action do |_global_options, options, _args|
        filter = options[:filter]&.downcase
        up = options[:up]
        App.api.fetch_scan_engines do |engine|
          next if filter && !engine.name.downcase.include?(filter)
          next if up && up != engine.up?

          puts engine.to_json
        end
      end
    end

    c.desc 'Send email when an engine is down'
    c.command :alert_on_down do |g|
      g.action do |_global_options, _options, _args|
        # TODO
        puts '... alert_on_down'
      end
    end

    c.desc 'Get scan engine by id'
    c.command :get do |g|
      g.desc 'Scan engine ID'
      g.flag :id
      g.action do |_global_options, options, _args|
        id = options[:id]
        credential = App.api.fetch_shared_credential(id)
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
