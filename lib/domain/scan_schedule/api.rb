# frozen_string_literal: true

require_relative '../../service/time_zone'
require_relative 'model'

class InsightVMApi
  def fetch_site_scan_schedules(site_id:)
    fetch_all("/sites/#{site_id}/scan_schedules") do |resource|
      yield ScanSchedule.from_json(resource)
    end
  end

  def all_site_scan_schedules(site_id:)
    schedules = []
    fetch_scan_schedules(site_id:) do |e|
      schedules << e
    end
    schedules
  end

  def create_weekly_scan(
    day_of_week:,
    start_hour:,
    country_code:, duration_in_hours:, site_id:, start_minute: 0,
    scan_name: nil,
    scan_engine_id: nil,
    scan_template_id: nil
  )
    now = DateTime.now
    year = now.year
    month = now.month
    day = now.day
    start_time = DateTime.new(year, month, day, start_hour, start_minute)
    local_time = Service::DateTime.closest_day_of_week(start_time, day_of_week)
    start = Service::TimeZone.iso8601(country_code:,
                                      local_time:)
    puts start
    puts scan_name
    puts country_code
    repeat = ScanSchedule::Repeat.new(
      every: 'week',
      day_of_week:,
      interval: 1
    )
    create_scan_schedule(
      site_id:,
      duration: "PT#{duration_in_hours}H",
      scan_engine_id:,
      scan_template_id:,
      repeat:,
      start:,
      scan_name:
    )
  end

  def delete_scan_schedule(site_id:, schedule_id:)
    delete("/sites/#{site_id}/scan_schedules", schedule_id)
  end

  def update_scan_schedule(scan_schedule, site_id:)
    id = scan_schedule.id
    endpoint = "/sites/#{site_id}/scan_schedules/#{id}"
    put(endpoint, scan_schedule)
  end

  def create_scan_schedule(
    site_id:,
    scan_engine_id:,
    scan_template_id:,
    duration:,
    repeat:,
    start:,
    on_scan_repeat: ScanSchedule::OnRepeat::RESTART,
    scan_name: nil, # required ISO8601 string
    excluded_asset_group_ids: [],
    included_asset_group_ids: [],
    excluded_targets: [],
    included_targets: [],
    enabled: false
  )
    params = {
      assets: {
        excludedAssetGroups: {
          assetGroupIDs: excluded_asset_group_ids
        },
        excludedTargets: {
          addresses: excluded_targets
        },
        includedAssetGroups: {
          assetGroupIDs: included_asset_group_ids
        },
        includedTargets: {
          addresses: included_targets
        }
      },
      duration:,
      enabled:,
      start:,
      repeat: JSON.parse(repeat.to_json),
      scanEngineId: scan_engine_id,
      scanTemplateId: scan_template_id,
      onScanRepeat: on_scan_repeat,
      scanName: scan_name

    }
    result = post("/sites/#{site_id}/scan_schedules", params)
    result&.dig('id')
  end
end
