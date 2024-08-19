# frozen_string_literal: true

require_relative 'model'

class InsightVMApi
  def fetch_reports
    fetch_all('/reports') do |resource|
      yield Report.from_json(resource)
    end
  end

  def fetch_report(report_id)
    fetch("/reports/#{report_id}") do |data|
      return Report.from_json(data)
    end
    nil
  end

  def fetch_report_by_name(name)
    fetch_reports do |report|
      return report if report.name.downcase == name.downcase
    end
    nil
  end

  def fetch_utr_reports
    reports = []
    fetch_reports do |report|
      reports << report if report.utr?
    end
    reports
  end

  def delete_utr_reports
    puts 'Fetching UTR reports can take up to 5 minutes, patience ...'
    reports = fetch_utr_reports
    # TODO: add progress bar
    raise 'No UTR reports were found.' if reports.empty?

    # TODO: ask for confirmation
    puts "#{reports.count} reports will be deleted. Are you sure?"
    reports.each do |report|
      next unless report.utr? # double-check

      puts "Deleting report #{report.name}"

      delete_report(report.id)
    end
  end

  def update_report_owner(report, owner_id)
    payload = report.to_hash.merge({ 'owner' => owner_id })
    payload.delete('id')
    payload.delete_if { |_k, v| v.nil? }
    endpoint = "/reports/#{report.id}"
    put(endpoint, payload)
  end

  def update_xxx_report_owner(owner_id)
    fetch_reports do |report|
      next unless report.name.starts_with?('xxx')
      next if report.owner == owner_id

      report.timezone = 'Africa/Harare'
      puts "Change #{report.name} owner from #{report.owner}"
      update_report_owner(report, owner_id)
    end
  end

  def create_report(
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
    result = post('/reports', params)
    result&.dig('id')
  end

  def create_utr_reports_for(
    business_unit:,
    cmdb_assets:,
    cached_tags: {},
    starts_discovery: true
  )
    assets = cmdb_assets.select { |asset| asset.business_unit == business_unit }
    report_names = assets.map(&:report_name).uniq
    report_names.each do |report_name|
      report_id = create_utr_report_from(
        report_name:,
        cmdb_assets: assets,
        cached_tags:
      )
      if report_id.nil?
        puts "Cannot create #{report_name} report"
        next
      end

      puts "\tCreate asset group: #{report_name}"
      create_asset_group_for(report_id:, report_name:)

      puts "\tSchedule the scan"
      # TODO

      next unless starts_discovery

      puts "\tStart discovery scan"
      starts_discovery_scan(report_id:)
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

  def delete_utr_report_schedules(report_id:)
    fetch_report_scan_schedules(report_id:) do |scan_schedule|
      delete_scan_schedule(report_id:, schedule_id: scan_schedule.id)
    end
  end

  def upsert_utr_report_schedule(report_id:)
    report = fetch_report(report_id)
    raise 'The report is not a valid UTR report' unless report.utr?

    delete_utr_report_schedules(report_id:)

    create_utr_report_schedule(report_id:)
  end

  def create_utr_report_schedule(report_id:)
    report = fetch_report(report_id)
    raise 'The report is not a valid UTR report' unless report.utr?

    scan_name = report.name
    report.utr_digits
    slot = scan_slot(report.utr_digits)
    country_code = report.country_code
    scan_template_id = report.scan_template_id
    duration_in_hours = 2

    create_weekly_scan(
      country_code:,
      day_of_week: slot[:day_of_week],
      start_hour: slot[:start_time],
      duration_in_hours:,
      report_id:,
      scan_name:,
      scan_template_id:
    )
  end

  # return report.id if success
  # only return the onboard assets
  def create_utr_report_from(
    report_name:, cmdb_assets:, cached_tags: {}
  )
    assets = cmdb_assets.select { |asset| asset.report_name == report_name }
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
    puts "Report #{report_name}\nTargets: #{targets.length} #{targets.join(' ')}"
    puts '-' * 40

    # TODO: check if the report already exists
    report_id = create_utr_report(
      name: report_name,
      description: report_name,
      targets:,
      engine_id:,
      scan_template_id:
    )
    if report_id.nil?
      puts "Report #{report_name} already exists!"
      return
    end

    # add report to shared credential
    report = fetch_report(report_id)
    add_shared_credentials(report)

    # tag assets with business unit code, sub_area, app + utr,
    tag_names = assets.first.utr_tag_names
    tags = tag_names.map do |tag_name|
      puts "\tAdd tag: #{tag_name}"
      upsert_tag(name: tag_name, cached_tags:)
    end
    tag_ids = tags.map(&:id)

    add_tags_to_site(report_id:, tag_ids:)
    report_id
  end

  def delete_report_by(id:, name:)
    raise 'Specify either id or name' if id.nil? && name.nil?

    if id
      delete_report(id)
    else
      report = fetch_report_by_name(name)
      delete_report(report.id)
    end
  end

  def delete_report(report_id)
    raise 'Cannot delete report without id' if report_id.nil?

    report = fetch_report(report_id)
    raise "Report #{report_id} does not exist." if report.nil?

    puts 'Delete asset group with the same name as the report'
    delete_asset_group_by(name: report.name)

    puts "Delete assets from report #{report_id}"
    delete("/reports/#{report_id}/assets", '')
    puts "Delete report #{report_id}"
    delete('/reports', report_id)
  end

  def create_utr_report(
    name:,
    description:,
    targets:,
    engine_id:,
    scan_template_id:
  )
    create_report(
      name:,
      description:,
      importance: 'high',
      engine_id:,
      scan_template_id:,
      included_targets: targets
    )
  end

  def fetch_report_shared_credentials(report_id:)
    report = fetch_report(report_id)
    raise "Report #{report_id} not found" if report.nil?

    fetch_report_cyberark_credentials(report)
  end

  def fetch_report_cyberark_credentials(report)
    country_code = report.country_code
    if country_code != 'za'
      country = find_by_country_code report.country_code
      Array(fetch_country_cyberark(country.name))
    else
      domains = fetch_report_domains(report)
      fetch_domain_cyberark(domains)
    end
  end

  def fetch_report_domains(report)
    fetch_report_target_domains(report.id)
  end
end
