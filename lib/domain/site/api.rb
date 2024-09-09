# frozen_string_literal: true

require_relative '../country/model'
require_relative 'model'

class InsightVMApi
  def settings
    {
      ar_vulnerability_scan_template_name: ENV['AR_VULNERABILITY_SCAN_TEMPLATE_NAME'],
      za_vulnerability_scan_template_name: ENV['ZA_VULNERABILITY_SCAN_TEMPLATE_NAME'],
      za_deep_dive_scanners: ENV['ZA_DEEP_DIVE_SCANNERS']
    }
  end

  def fetch_sites
    return to_enum(__method__) unless block_given?

    fetch_all('/sites') do |resource|
      yield Site.from_json(resource)
    end
  end

  def fetch_site(site_id)
    fetch("/sites/#{site_id}") do |data|
      return Site.from_json(data)
    end
    nil
  end

  def fetch_site_by_name(name)
    fetch_sites.find do |site|
      site.name.downcase == name.downcase
    end
  end

  def site_exists?(name)
    !fetch_site_by_name(name).nil?
  end

  # def fetch_cmdb_vulnerability_scan_sites
  #   return to_enum(__method__) unless block_given?

  #   fetch_sites.select(&:cmdb_vulnerability?).each do |site|
  #     discovery_site = CmdbVulnerabilitySite.new(
  #       id: site.id,
  #       name: site.name,
  #       scan_engine: site.scan_engine,
  #       scan_template: site.scan_template
  #     )
  #     yield discovery_site
  #   end
  # end

  def fetch_country_discovery_sites
    return to_enum(__method__) unless block_given?

    fetch_sites.select(&:country_discovery?).each do |site|
      discovery_site = CountryDiscoverySite.new(
        id: site.id,
        name: site.name,
        scan_engine: site.scan_engine,
        scan_template: site.scan_template
      )
      yield discovery_site
    end
  end

  def fetch_cmdb_discovery_sites
    return to_enum(__method__) unless block_given?

    fetch_sites.select(&:cmdb_discovery?).each do |site|
      discovery_site = CountryDiscoverySite.new(
        id: site.id,
        name: site.name,
        scan_engine: site.scan_engine,
        scan_template: site.scan_template
      )
      yield discovery_site
    end
  end

  def fetch_utr_sites
    fetch_sites.select(&:utr?).to_a
  end

  def delete_utr_sites(confirmation: true)
    puts 'Fetching UTR sites can take up to 5 minutes, patience ...'
    sites = fetch_utr_sites
    # TODO: add progress bar
    raise 'No UTR sites were found.' if sites.empty?

    # TODO: ask for confirmation
    prompt = "#{sites.count} sites will be deleted. Are you sure?"
    if confirmation && !confirm_action(prompt)
      puts 'Operation cancelled. No UTR sites were deleted.'
      return
    end

    sites.each do |site|
      next unless site.utr? # double-check

      puts ''
      puts "Deleting site #{site.name}"

      delete_site(site.id)
    end
  end

  # Creates a new site with the given parameters
  #
  # @param options [Hash] Options for site creation
  # @option options [String] :name The name of the site (required)
  # @option options [String] :description The description of the site (required)
  # @option options [String] :engine_id The ID of the scan engine to use (required)
  # @option options [String] :scan_template_id The ID of the scan template to use (required)
  # @option options [String] :importance ('normal') The importance of the site
  # @option options [Array<String>] :included_targets ([]) Targets to include in the scan
  # @option options [Array<String>] :excluded_targets ([]) Targets to exclude from the scan
  # @option options [Array<String>] :included_asset_group_ids ([]) Asset group IDs to include
  # @option options [Array<String>] :excluded_asset_group_ids ([]) Asset group IDs to exclude
  # @return [String, nil] The ID of the created site, or nil if creation failed
  # @raise [ArgumentError] If any required option is missing
  def create_site(options = {})
    default_options = {
      importance: 'normal',
      included_targets: [],
      excluded_targets: [],
      included_asset_group_ids: [],
      excluded_asset_group_ids: []
    }

    options = default_options.merge(options)

    required_keys = %i[name description engine_id scan_template_id]
    missing_keys = required_keys.select { |key| options[key].nil? }
    raise ArgumentError, "Missing required options: #{missing_keys.join(',')}" if missing_keys.any?

    params = {
      name: options[:name],
      description: options[:description],
      importance: options[:importance],
      engineId: options[:engine_id],
      scanTemplateId: options[:scan_template_id],
      scan: {
        assets: {
          includedTargets: {
            addresses: options[:included_targets]
          },
          excludedTargets: {
            addresses: options[:excluded_targets]
          },
          includedAssetGroups: {
            assetGroupIDs: options[:included_asset_group_ids]
          },
          excludedAssetGroups: {
            assetGroupIDs: options[:excluded_asset_group_ids]
          }
        }
      }
    }

    result = post('/sites', params)
    result&.dig('id')
  end

  # TODO: mark this function for deletion
  def create_utr_sites_for(
    business_unit:,
    cmdb_assets:,
    cached_tags: {},
    starts_discovery: true
  )
    assets = cmdb_assets.select { |asset| asset.business_unit == business_unit }
    site_names = assets.map(&:site_name).uniq
    site_names.each do |site_name|
      site_id = create_utr_site_from(
        site_name:,
        cmdb_assets: assets,
        cached_tags:
      )
      if site_id.nil?
        puts "Cannot create #{site_name} site"
        next
      end

      puts "\t Create asset group: #{site_name}"
      create_asset_group_for(site_id:, site_name:)

      puts "\t Schedule the scan"
      # TODO

      next unless starts_discovery

      puts "\t Start discovery scan"
      starts_discovery_scan(site_id:)
    end
  end

  # return day of week and starts Time
  # of scan ScanSchedule
  # given the UTR digits
  def scan_slot(utr_digits)
    index = utr_digits % 25
    day = index / 5
    hour = index % 5

    days = %w[monday tuesday friday saturday sunday]
    hours = [20, 22, 0, 2, 4]

    {
      day_of_week: days[day],
      start_time: hours[hour]
    }
  end

  def delete_utr_site_schedules(site_id:)
    fetch_site_scan_schedules(site_id:) do |scan_schedule|
      delete_scan_schedule(site_id:, schedule_id: scan_schedule.id)
    end
  end

  def upsert_utr_site_schedule(site_id:)
    sitee(site_id)
    raise 'The site is not a valid UTR site' unless site.utr?

    delete_utr_site_schedules(site_id:)

    create_utr_site_schedule(site_id:)
  end

  def toggle_utr_site_schedule(site)
    site_id = site.id
    fetch_site_scan_schedules(site_id:) do |scan_schedule|
      next if scan_schedule.enabled == enabled

      scan_schedule.enabled = enabled
      update_scan_schedule(scan_schedule, site_id:)
    end
  end

  def create_utr_site_schedule(site_id:)
    sitee(site_id)
    raise 'The site is not a valid UTR site' unless site.utr?

    scan_name = site.name
    slot = scan_slot(site.utr_digits)
    country_code = site.country_code
    scan_template_id = site.scan_template_id
    duration_in_hours = 2

    create_weekly_scan(
      country_code:,
      day_of_week: slot[:day_of_week],
      start_hour: slot[:start_time],
      duration_in_hours:,
      site_id:,
      scan_name:,
      scan_template_id:
    )
  end

  def get_vulnerability_scan_template_name(country_code)
    if country_code == 'za'
      settings[:za_vulnerability_scan_template_name]
    else
      settings[:ar_vulnerability_scan_template_name]
    end
  end

  def fetch_or_create_asset_group_for_cmdb_vulnerability_scan(site)
    asset_group = fetch_asset_group_by_name(site.asset_group_name)
    return asset_group.id unless asset_group.nil?

    filters = [site.country_code, site.network_zone, site.business_unit_code].map do |tag|
      {
        field: 'custom-tag',
        operator: 'is',
        value: tag
      }
    end

    create_asset_group(
      name: site.asset_group_name,
      description: "Asset Group for #{site.name}",
      search_criteria: { match: 'all', filters: }
    )
  end

  def fetch_vulnerability_scan_engine_pool(_site)
    # TODO
    ScanEngine.new({ id: 50 })
  end

  def create_cmdb_vulnerability_site(
    vulnerability_site:,
    enable_schedule: false
  )
    asset_group_id = fetch_or_create_asset_group_for_cmdb_vulnerability_scan(vulnerability_site)
    raise "#{vulnerability_site.asset_group_name} asset group not found" if asset_group_id.nil?

    country_code = vulnerability_site.country_code
    scan_template = fetch_vulnerability_scan_template(country_code)

    site_id = create_site(
      name: vulnerability_site.name,
      description: vulnerability_site.name,
      importance: 'high',
      included_asset_group_ids: [asset_group_id],
      engine_id: vulnerability_site.scan_engine_pool_id,
      scan_template_id: scan_template.id
    )
    raise "#{vulnerability_site.name} site was not created" if site_id.nil?

    add_site_shared_credentials(
      cmdb_site_id: site_id,
      country_discovery_site_id: vulnerability_site.country_discovery_site_id
    )

    # TODO: add the schedule
    puts 'Enable schedule' if enable_schedule
    site_id
  rescue StandardError => e
    puts "Error occured while creating site: #{e.message}"
    puts e.backtrace.join("\n")
    puts "Delete partially created #{vulnerability_site.name}"
    delete_site(site_id) unless site_id.nil?
    nil
  end

  def create_cmdb_discovery_site(
    discovery_site:,
    starts_discovery: true
  )
    site_id = create_utr_site(
      name: discovery_site.name,
      description: discovery_site.name,
      targets: discovery_site.included_targets,
      engine_id: discovery_site.scan_engine,
      scan_template_id: discovery_site.scan_template
    )

    if site_id.nil?
      puts "#{discovery_site.name} site was not created"
      return
    end
    add_site_shared_credentials(
      cmdb_site_id: site_id,
      country_discovery_site_id: discovery_site.country_discovery_site_id
    )
    add_site_tags(
      site_id:,
      tag_names: discovery_site.tag_names
    )
    starts_discovery_scan(site_id) if starts_discovery
    site_id
  rescue StandardError => e
    puts "Error occured while creating site: #{e.message}"
    puts e.backtrace.join("\n")
    puts "Delete partially created #{discovery_site.name}"
    delete_site(site_id) unless site_id.nil?
    nil
  end

  def add_site_tags(site_id:, tag_names:)
    tags = tag_names.map do |tag_name|
      upsert_tag(name: tag_name)
    end
    return nil if tags.nil?

    tag_ids = tags.map(&:id)
    add_tags_to_site(site_id:, tag_ids:)
  end

  def add_site_shared_credentials(
    cmdb_site_id:,
    country_discovery_site_id:
  )
    credentials = fetch_assigned_shared_credentials(
      site_id: country_discovery_site_id
    )
    site_ids = [cmdb_site_id]
    credentials.each do |credential|
      update_shared_credential_sites(
        credential:,
        site_ids:
      )
    end
  end

  # return site.id if success
  # Note: only return the onboard assets
  def create_utr_site_from(
    site_name:,
    cmdb_assets:,
    cached_tags: {}
  )
    assets = cmdb_assets.select { |asset| asset.site_name == site_name }
                        .select(&:onboard?)

    return if assets.empty?

    country = assets.first.country
    targets = assets.map(&:fqdn)
    sitentry_scan_engine_pools(country)
    # puts "Scan engine pool #{scan_engine_pool}"
    engine_id = site[:id]
    scan_template_id = fetch_vulnerability_scan_template_id(country)
    puts
    puts '-' * 40
    puts "Site #{site_name}\nTargets: #{targets.length} #{targets.join(' ')}"
    puts '-' * 40

    # TODO: check if the site already exists
    site_id = create_utr_site(
      name: site_name,
      description: site_name,
      targets:,
      engine_id:,
      scan_template_id:
    )
    if site_id.nil?
      puts "Site #{site_name} already exists!"
      return
    end

    # add site to shared credential
    site = fetch_site(site_id)
    add_shared_credentials(site)

    # tag assets with business unit code, sub_area, app + utr,  network_zone
    tag_names = assets.first.utr_tag_names
    tags = tag_names.map do |tag_name|
      puts "\tAdd tag: #{tag_name}"
      upsert_tag(name: tag_name)
    end
    tag_ids = tags.map(&:id)

    add_tags_to_site(site_id:, tag_ids:)
    site_id
  end

  def upsert_site_shared_credentials(site_id:)
    sitee(site_id)
    raise "Site #{site_id} does not exist." if site.nil?
    raise "Site #{site.name} is not a UTR site" unless site.utr?

    add_shared_credentials(site)
  end

  def add_shared_credentials(site)
    site_ids = [site.id]
    shared_credentials = fetch_site_cyberark_credentials(site)
    shared_credentials.each do |credential|
      puts "#{site.name} Shared Credential #{credential.name}"
      update_shared_credential_sites(credential:, site_ids:)
    end
  end

  def starts_discovery_scan(site_id)
    params = {}
    post("/sites/#{site_id}/scans", params)
  end

  def delete_site_by(id:, name:)
    raise 'Specify either id or name' if id.nil? && name.nil?

    site_id = id || fetch_site_by_name(name)&.id
    delete_site(site_id) unless site_id.nil?
  end

  def delete_site(site_id, cascade: true)
    raise 'Cannot delete site without id' if site_id.nil?

    if cascade
      site = fetch_site(site_id)
      raise "Site #{site_id} does not exist." if site.nil?

      puts "\t Delete asset group with the same name as the site"
      delete_asset_group_by(name: site.name)

      puts "\t Remove #{site.assets} assets from site"
      delete("/sites/#{site_id}/assets", '')
    end
    delete('/sites', site_id)
  end

  def create_utr_site(
    name:,
    description:,
    targets:,
    engine_id:,
    scan_template_id:
  )
    create_site(
      name:,
      description:,
      importance: 'high',
      engine_id:,
      scan_template_id:,
      included_targets: targets
    )
  end

  def fetch_site_shared_credentials(site_id:)
    sitee(site_id)
    raise "Site #{site_id} not found" if site.nil?

    fetch_site_cyberark_credentials(site)
  end

  def fetch_site_cyberark_credentials(_site)
    country_code = scan_engine_pool.country_code
    if country_code != 'za'
      country = find_by_country_code scan_engine_pool.country_code
      Array(fetch_country_cyberark(country.name))
    else
      domains = fetch_site_domains(scan_engine_pool)
      fetch_domain_cyberark(domains)
    end
  end

  def fetch_site_domains(_site)
    fetch_site_target_domains(scan_engine_pool.id)
  end
end
