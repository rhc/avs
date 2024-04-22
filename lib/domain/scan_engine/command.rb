# frozen_string_literal: true

require_relative 'model'
# require_relative '../../service/mail'

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

    c.desc 'Send email when previously up engines go down'
    c.command :alert_on_down do |a|
      a.desc 'Previous scan engine statuses'
      a.flag [:previous_status]
      a.action do |_global_options, options, _args|
        csv_file = options[:previous_status] || ENV['SCAN_ENGINE_PREVIOUS_STATUS']

        api = App.api
        previous_status = api.engine_last_status_from csv_file
        engines = api.all_scan_engines
        from_up_to_down = api.scan_engines_from_up_to_down(engines, previous_status)
        from_up_to_down.each do |engine|
          puts engine.to_json
        end

        unless from_up_to_down.empty?
          count = from_up_to_down.count
          mail_service = App.mail
          alert_time = Time.now.strftime('%Y-%m-%d %H:%M')
          subject = 'Scan Engine Down Alert'
          pluralize_scan_engine = count == 1 ? '1 scan engine has' : "#{count} engines have"

          body = "<p>As of #{alert_time}, we've detected that #{pluralize_scan_engine} gone offline:</p>"
          body << '<ol>'
          from_up_to_down.each do |engine|
            body << "<li>#{engine.name}</li>"
          end
          body << '</ol>'
          body << '<p>Take steps to bring the scan engines back online as soon as possible.</p>'
          body << "<p>You can access more details about the engine status on the <a href='https://sbginsightvmconsole.standardbank.co.za:3780/admin/engine/listing.jsp'>console</a>.</p>"

          mail_service.send(subject:, body:)
        end
        # write the new status
        api.append_new_status(engines:, previous_status:, csv_file:)
      end
    end

    c.desc 'Get scan engine by id'
    c.command :get do |g|
      g.desc 'Scan engine ID'
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
