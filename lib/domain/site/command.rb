# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage sites'
  command :site do |c|
    c.flag :id, desc: 'Unique ID', type: Integer
    c.flag :name, desc: 'Name'
    c.desc 'List sites'

    c.command :list do |l|
      l.switch [:utr], desc: 'UTR site only'

      l.action do |_global_options, options, _args|
        name = options[GLI::Command::PARENT][:name]&.downcase
        utr = options[:utr]
        App.api.fetch_sites do |site|
          next if name && !site.name.downcase.include?(name)
          next if utr && !site.utr?

          puts site.to_json
        end
      end
    end

    c.desc 'List UTR sites from cmdb'
    c.command :utr_from_cmdb do |ldb|
      ldb.action do |_global_options, options, _args|
        name = options[GLI::Command::PARENT][:name]&.downcase
        App.db.fetch_utr_site_from_cmdb do |site|
          next if name && !site.name.downcase.include?(name)

          puts site.to_json
        end
      end
    end

    c.desc 'Get site by id'
    c.command :get do |g|
      g.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        puts "TODO get site id #{id}"
      end
    end

    c.desc 'List scan schedules'
    c.command :scan_schedules do |g|
      # TODO: add the switch
      # g.switch [:enabled], desc: 'Only enabled schedules', default_value: nil, negatable: true
      g.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        enabled = options[:enabled]
        puts enabled
        raise 'Site ID is required' if site_id.nil?

        App.api.fetch_site_scan_schedules(site_id:) do |schedule|
          puts schedule.to_json # if enabled.nil? || enabled == schedule.enabled
        end
      end
    end

    c.desc 'Add tag to site'
    c.command :add_tag do |at|
      at.flag [:tag_name], desc: 'Tag Name'
      at.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        tag_name = options[:tag_name]
        if tag_name.nil?
          puts 'Tag name is required'
          exit
        end
        tag = App.api.get_or_create_tag(name: tag_name)
        puts "Tag #{tag.to_json}"
        App.api.add_utr_tags(site_id: id, tag_ids: [tag.id])
      end
    end

    c.desc 'Add weekly schedule to UTR site'
    c.command :schedule_utr do |s|
      s.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        raise 'The site id is required' if site_id.nil?

        schedule_id = App.api.create_utr_site_schedule(
          site_id:
        )
        puts 'Schedule created' unless schedule_id.nil?
      end
    end

    c.desc 'Add weekly schedule to site'
    c.command :schedule do |s|
      s.flag [:every], desc: 'Day of the week'
      s.flag [:at], desc: 'Hour', type: Integer
      s.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        raise 'The site id is required' if site_id.nil?

        every = options[:every]
        at = options[:at]
        if every.nil?
          puts 'The day of the week is required'
          exit
        end
        schedule_id = App.api.create_weekly_scan(
          day_of_week: every,
          start_time: at,
          duration_in_hours: 2,
          site_id:
        )
        puts 'Schedule created' unless schedule_id.nil?
      end
    end

    c.desc 'Create sites for business unit'
    c.command :new do |n|
      n.flag [:bu, :business_unit, 'business-unit'], desc: 'Business unit'
      n.switch ['starts-discovery', :starts_discovery], desc: 'Starts a discovery scan for each site',
                                                        default_value: true

      n.action do |_global_options, options, _args|
        business_unit = options[:business_unit]
        if business_unit.nil?
          puts 'Cannot create a new site without the business unit name.'
          exit
        end
        starts_discovery = options[:starts_discovery]
        puts 'Fetching assets from CMDB ...'
        cmdb_assets = App.db.fetch_cmdb_assets
        App.api.create_utr_sites_for(
          business_unit:,
          cmdb_assets:,
          starts_discovery:
        )
      end
    end

    c.desc 'Delete site by id or name'
    c.command :delete do |d|
      d.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        name = options[GLI::Command::PARENT][:name]
        App.api.delete_site_by id:, name:
      end
    end

    c.desc 'Starts a discovery scan for the site'
    c.command :starts_discovery_scan do |d|
      d.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        raise 'You must specify the site id.' if site_id.nil?

        App.api.starts_discovery_scan(site_id:)
      end
    end

    c.desc 'Delete all UTR sites'
    c.command :delete_utr_sites do |d|
      d.action do |_global_options, _options, _args|
        App.api.delete_utr_sites
      end
    end
  end
end
