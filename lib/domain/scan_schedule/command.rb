# frozen_string_literal: true

require_relative 'model'
# require_relative '../../service/mail'

class App
  desc 'Manage scan schedules'
  command :scan_schedule do |c|
    c.flag :id, desc: 'Unique ID', type: Integer
    c.flag [:site_id, 'site-id'], type: Integer, required: true
    c.flag :name, desc: 'Name'
    c.desc 'List site scan schedules'

    c.command :list do |l|
      l.switch [:enabled], desc: 'Only enabled scan schedules'
      # TODO: l.desc 'Status (all|up|down)'
      l.action do |_global_options, options, _args|
        name = options[GLI::Command::PARENT][:name]&.downcase
        site_id = options[GLI::Command::PARENT][:site_id]
        # enabled = options[:enabled]
        App.api.fetch_site_scan_schedules(site_id:) do |schedule|
          next if name && !schedule.name.downcase.include?(name)
          # next if enabled && enabled != schedule.enabled?

          puts schedule.to_json
        end
      end
    end

    c.desc 'Get scan schedule by id'
    c.command :get do |g|
      g.desc 'Scan schedule ID'
      g.action do |_global_options, options, _args|
        id = options[GLI::Command::Parent][:id]
        scan_schedule = App.api.fetch_scan_schedule(id)
        puts scan_schedule.to_json
      end
    end
    # c.desc 'Delete scan schedules'
    # c.command :delete do |d|
    #   d.desc 'scan schedule unique ID'
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
