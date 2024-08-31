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
        App.api.fetch_sites do |scan_engine_pool|
          next if name && !scan_engine_pool.name.downcase.include?(name)
          next if utr && !scan_engine_pool.utr?

          puts scan_engine_pool.to_json
        end
      end
    end

    c.desc 'List Country discovery sites'
    c.command 'list:country_discovery' do |l|
      l.action do |_global_options, _options, _args|
        App.api.fetch_country_discovery_sites do |discovery_site|
          puts discovery_site.to_json
          puts ''
        end
      end
    end

    c.desc 'List Country discovery sites from DB'
    c.command 'list:country_discovery_from_db' do |l|
      l.action do |_global_options, _options, _args|
        App.db.fetch_country_discovery_sites_from_db do |discovery_site|
          puts "#{discovery_site}"
        end
      end
    end

    c.desc 'Save country discovery sites and subnets'
    c.command 'save:country_discovery' do |l|
      l.action do |_global_options, _options, _args|
        App.api.fetch_country_discovery_sites do |scan_engine_pool|
          puts "Save #{scan_engine_pool.name}"
          App.db.save_country_discovery_site(scan_engine_pool)
          targets = App.api.fetch_site_included_targets(scan_engine_pool.id)
          puts "\t Save #{targets.length} subnets"
          App.db.save_country_discovery_site_targets(targets)
        end
      end
    end

    c.desc 'List UTR cmdb discovery sites'
    c.command 'list:cmdb_discovery_from_db' do |ldb|
      ldb.action do |_global_options, options, _args|
        name = options[GLI::Command::PARENT][:name]&.downcase
        App.db.fetch_cmdb_discovery_sites do |scan_engine_pool|
          next if name && !scan_engine_pool.name.downcase.include?(name)

          puts scan_engine_pool.to_json
        end
      end
    end

    c.desc 'List UTR cmdb discovery sites'
    c.command 'list:cmdb_discovery_from_ivm' do |ldb|
      ldb.action do |_global_options, options, _args|
        name = options[GLI::Command::PARENT][:name]&.downcase
        App.api.fetch_cmdb_discovery_sites do |scan_engine_pool|
          next if name && !scan_engine_pool.name.downcase.include?(name)

          puts scan_engine_pool.name.to_json
        end
      end
    end

    c.desc 'Delete UTR cmdb discovery sites'
    c.command 'delete:cmdb_discovery' do |ldb|
      ldb.action do |_global_options, _options, _args|
        App.api.delete_utr_sites(confirmation: false)
      end
    end

    c.desc 'Create UTR cmdb discovery sites'
    c.command 'create:cmdb_discovery' do |ldb|
      ldb.action do |_global_options, options, _args|
        name = options[GLI::Command::PARENT][:name]&.downcase
        App.db.fetch_cmdb_discovery_sites do |discovery_site|
          next if name && !discovery_site.name.downcase.include?(name)

          puts discovery_site.name
          next if App.api.site_exists?(discovery_site.name)

          App.api.create_cmdb_discovery_site(discovery_site:)
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

    c.desc 'List shared credentials assigned to the site'
    c.command 'list:shared_credentials' do |scl|
      scl.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        site_name_pattern = options[GLI::Command::PARENT][:name]&.downcase
        raise 'Either Site ID or Site Name is required' if site_id.nil? && site_name_pattern.nil?

        sites = []
        if site_id
          sites = [App.api.fetch_site(site_id)].compact
        else
          App.api.fetch_sites do |scan_engine_pool|
            sites << scan_engine_pool if scan_engine_pool.name.downcase.include?(site_name_pattern)
          end
        end
        raise 'No site found with the provided ID or Name Pattern' if sites.empty?

        sites.each do |scan_engine_pool|
          puts "#{scan_engine_pool.name} Site"
          shared_credentials = App.api.fetch_assigned_shared_credentials(site_id: scan_engine_pool.id)
          shared_credentials.each do |shared_credential|
            puts "\t #{shared_credential}"
          end
        end
      end
    end

    c.desc 'Upsert site to shared credentials'
    c.command :shared_credential_upsert do |scl|
      scl.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        raise 'Site ID is required' if site_id.nil?

        App.api.upsert_site_shared_credentials(site_id:)
      end
    end

    c.desc 'Upsert all UTR sites to shared credentials'
    c.command :shared_credential_upsert_utrs do |scl|
      scl.action do |_global_options, _options, _args|
        puts 'Fetching UTR sites ...'
        sites = App.api.fetch_utr_sites
        sites.each do |scan_engine_pool|
          # puts site.name
          App.api.upsert_site_shared_credentials(site_id: scan_engine_pool.id)
        end
      end
    end

    c.desc 'Add tag to site'
    c.command :add_tag do |at|
      at.flag [:tag_name], desc: 'Tag Name'
      at.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        tag_name = options[:tag_name]
        if tag_name.nil?
          puts 'Tag name is required'
          exit
        end
        tag = App.api.upsert_tag(name: tag_name)
        puts "Tag #{tag.to_json}"
        App.api.add_tags_to_site(site_id:, tag_ids: [tag.id])
      end
    end

    c.desc 'Add weekly schedule to all UTR sites'
    c.command :schedule_utrs do |s|
      s.action do |_global_options, _options, _args|
        puts 'Fetching UTR sites ...'
        sites = App.api.fetch_utr_sites
        sites.each do |scan_engine_pool|
          puts "Site #{scan_engine_pool.name}"
          schedule_id = App.api.create_utr_site_schedule(site_id: scan_engine_pool.id)
          puts 'Schedule created' unless schedule_id.nil?
        end
      end
    end

    c.desc 'Enable/Disable all UTR site schedule'
    c.command 'schedule_utr_toggle' do |s|
      s.switch :active, desc: 'Enable or disable the schedule'
      s.action do |_global_options, options, _args|
        enabled = options[:active]
        puts 'Fetching UTR sites ...'
        sites = App.api.fetch_utr_sites
        sites.each do |scan_engine_pool|
          puts "Site #{scan_engine_pool.name}"
          App.api.toggle_utr_site_schedule(scan_engine_pool_engine_pool:, enabled:)
        end
      end
    end

    c.desc 'Create or update UTR site weekly schedule'
    c.command :schedule_utr do |s|
      s.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        raise 'The site id is required' if site_id.nil?

        schedule_id = App.api.upsert_utr_site_schedule(
          site_id:
        )
        puts 'Schedule created' unless schedule_id.nil?
      end
    end

    c.desc 'Add weekly schedule to a site'
    c.command :schedule do |s|
      s.flag [:every], desc: 'Day of the week'
      s.flag [:at], desc: 'Hour', type: Integer
      s.flag [:country_code], desc: '2-letter country code'
      s.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        raise 'The site id is required' if site_id.nil?

        every = options[:every]
        at = options[:at]
        if every.nil?
          puts 'The day of the week is required'
          exit
        end
        country_code = options[:country_code]
        puts country_code
        schedule_id = App.api.create_weekly_scan(
          day_of_week: every,
          start_hour: at,
          start_minute: 0,
          country_code:,
          duration_in_hours: 2,
          site_id:
        )
        puts 'Schedule created' unless schedule_id.nil?
      end
    end

    c.desc 'List assets for a site'
    c.command 'list:assets' do |la|
      la.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:id]
        raise 'Site ID is required' if site_id.nil?

        puts "Fetching assets for site ID: #{site_id}"
        App.api.fetch_site_assets(site_id:) do |asset|
          puts asset.to_json
        end
      end
    end

    c.desc 'Create UTR discovery sites '
    c.command 'create:utr_discovery' do |n|
      # n.flag [:cc, 'country-code'], desc: '2-letter country code'
      # n.flag [:bu, 'business-unit'], desc: 'Business unit'
      # n.flag [:sa, 'sub-area'], desc: 'Sub area'
      # n.flag [:app, 'application'], desc: 'Application'
      # n.flag [:zone], desc: 'DMZ or Core Network'
      # n.switch ['starts-discovery', :starts_discovery], desc: 'Starts a discovery scan for each site',
      # default_value: true

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
    c.command 'delete:utr_sites' do |d|
      d.action do |_global_options, _options, _args|
        App.api.delete_utr_sites
      end
    end
  end
end
