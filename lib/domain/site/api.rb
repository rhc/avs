# frozen_string_literal: true

require_relative '../country/model'
require_relative 'model'

class InsightVMApi
  def settings
    {
      ar_discovery_template_id: ENV['AR_DISCOVERY_TEMPLATE_ID'],
      za_discovery_template_id: ENV['ZA_DISCOVERY_TEMPLATE_ID'],
      za_deep_dive_scanners: ENV['ZA_DEEP_DIVE_SCANNERS']
    }
  end

  def fetch_sites
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
    fetch_sites do |site|
      return site if site.name.downcase == name.downcase
    end
    nil
  end

  def fetch_utr_sites
    sites = []
    fetch_sites do |site|
      sites << site if site.utr?
    end
    sites
  end

  def delete_utr_sites
    puts 'Fetching UTR sites can take up to 5 minutes, patience ...'
    sites = fetch_utr_sites
    # TODO: add progress bar
    raise 'No UTR sites were found.' if sites.empty?

    # TODO: ask for confirmation
    puts "#{sites.count} sites will be deleted. Are you sure?"
    sites.each do |site|
      next unless site.utr? # double-check

      puts "Deleting site #{site.name}"

      delete_site(site.id)
    end
  end

  def create_site(
    name:,
    description:,
    engine_id:,
    scan_template_id:,
    importance: 'normal',
    included_targets: [],
    excluded_targets: [],
    included_asset_group_ids: [],
    excluded_asset_group_ids: []
  )
    # Construct the request body
    params = {
      name:,
      description:,
      importance:,
      engineId: engine_id,
      scanTemplateId: scan_template_id,
      scan: {
        assets: {
          includedTargets: {
            addresses: included_targets
          },
          excludedTargets: {
            addresses: excluded_targets
          },
          includedAssetGroups: {
            assetGroupIDs: included_asset_group_ids
          },
          excludedAssetGroups: {
            assetGroupIDs: excluded_asset_group_ids
          }
        }
      }
    }
    result = post('/sites', params)
    result&.dig('id')
  end

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

      puts "\tCreate asset group: #{site_name}"
      create_asset_group_for(site_id:, site_name:)

      puts "\tSchedule the scan"
      # TODO

      next unless starts_discovery

      puts "\tStart discovery scan"
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
    site = fetch_site(site_id)
    raise 'The site is not a valid UTR site' unless site.utr?

    delete_utr_site_schedules(site_id:)

    create_utr_site_schedule(site_id:)
  end

  def create_utr_site_schedule(site_id:)
    site = fetch_site(site_id)
    raise 'The site is not a valid UTR site' unless site.utr?

    scan_name = site.name
    site.utr_digits
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

  def fetch_discovery_scan_template_id(country)
    if country == 'South Africa'
      settings[:za_discovery_template_id]
    else
      settings[:ar_discovery_template_id]
    end
  end

  # return site.id if success
  # only return the onboard assets
  def create_utr_site_from(
    site_name:, cmdb_assets:, cached_tags: {}
  )
    assets = cmdb_assets.select { |asset| asset.site_name == site_name }
                        .select(&:onboard?)

    return if assets.empty?

    country = assets.first.country
    targets = assets.map(&:fqdn)
    scan_engine_pool = fetch_country_scan_engine_pools(country)
    # puts "Scan engine pool #{scan_engine_pool}"
    engine_id = scan_engine_pool[:id]
    scan_template_id = fetch_discovery_scan_template_id(country)
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

    # tag assets with business unit code, sub_area, app + utr,
    tag_names = assets.first.utr_tag_names
    tags = tag_names.map do |tag_name|
      puts "\tAdd tag: #{tag_name}"
      get_or_create_tag(name: tag_name, cached_tags:)
    end
    tag_ids = tags.map(&:id)

    add_utr_tags(site_id:, tag_ids:)
    site_id
  end

  def add_shared_credentials(site)
    site_ids = [site.id]
    shared_credentials = fetch_site_cyberark_credentials(site)
    shared_credentials.each do |credential|
      update_shared_credential_sites(credential:, site_ids:)
    end
  end

  def add_utr_tags(site_id:, tag_ids:)
    tag_ids.each do |tag_id|
      put("/sites/#{site_id}/tags/#{tag_id}", nil)
    end
  end

  def starts_discovery_scan(site_id:)
    site = fetch_site(site_id)
    raise "Site ##{siteId} does not exist." if site.nil?

    params = {}
    post("/sites/#{site_id}/scans", params)
  end

  def delete_site_by(id:, name:)
    raise 'Specify either id or name' if id.nil? && name.nil?

    if id
      delete_site(id)
    else
      site = fetch_site_by_name(name)
      delete_site(site.id)
    end
  end

  def delete_site(site_id)
    raise 'Cannot delete site without id' if site_id.nil?

    site = fetch_site(site_id)
    raise "Site #{site_id} does not exist." if site.nil?

    puts 'Delete asset group with the same name as the site'
    delete_asset_group_by(name: site.name)

    puts "Delete assets from site #{site_id}"
    delete("/sites/#{site_id}/assets", '')
    puts "Delete site #{site_id}"
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
    site = fetch_site(site_id)
    raise "Site #{site_id} not found" if site.nil?

    fetch_site_cyberark_credentials(site)
  end

  def fetch_site_cyberark_credentials(site)
    country_code = site.country_code
    if country_code != 'za'
      country = find_by_country_code site.country_code
      Array(fetch_country_cyberark(country.name))
    else
      domains = fetch_site_domains(site)
      fetch_domain_cyberark(domains)
    end
  end

  def fetch_site_domains(site)
    fetch_site_target_domains(site.id)
  end
end
