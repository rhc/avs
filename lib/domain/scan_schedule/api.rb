# frozen_string_literal: true

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
    start_time:,
    time_zone:,
    duration_in_hours:,
    site_id:,
    scan_name: nil,
    scan_engine_id: nil,
    scan_template_id: nil
  )
    now = DateTime.now
    year = now.year
    month = now.month
    day = now.day
    # starts_at = DateTime.new(year, month, day, start_time, 0, 0, Rational(time_zone, 24))
    # start = starts_at.to_s
    start = '2023-10-05T15:45:30+01:00[Africa/Kinshasa]'
    puts start
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
      repeat:,
      scanEngineId: scan_engine_id,
      scanTemplateId: scan_template_id,
      onScanRepeat: on_scan_repeat,
      scanName: scan_name

    }
    result = post("/sites/#{site_id}/scan_schedules", params)
    result&.dig('id')
  end
end
