# frozen_string_literal: true

require_relative 'repeat'

class ScanSchedule
  module OnRepeat
    RESTART = 'restart-scan'
    RESUME = 'resume-scan'
  end

  attr_accessor :id,
                :duration,
                :enabled,
                :next_runtimes,
                :on_scan_repeat,
                :repeat,
                :scan_engine_id,
                :scan_name,
                :scan_template_id,
                :start

  def initialize(
    site_idte_idte_idte_id:,
    next_runtimes:,
    on_scan_repeat:,
    scan_engine_id:,
    start:, duration: nil,
    enabled: false,
    repeat: nil,
    scan_name: nil,
    scan_template_id: nil
  )
    @id = site_idte_id
    @duration = duration
    @enabled = enabled
    @next_runtimes = next_runtimes
    @on_scan_repeat = on_scan_repeat
    @repeat = repeat
    @scan_engine_id = scan_engine_id
    @scan_name = scan_name
    @scan_template_id = scan_template_id
    @start = start
  end

  def self.from_json(data)
    ScanSchedule.new(
      id: data['id'],
      duration: data['duration'],
      enabled: data['enabled'],
      next_runtimes: data['nextRuntimes'],
      on_scan_repeat: data['onScanRepeat'],
      repeat: data['repeat'],
      scan_engine_id: data['scanEngineId'],
      scan_name: data['scanName'],
      scan_template_id: data['scanTemplateId'],
      start: data['start']
    )
  end

  # def self.slots(index)
  #   days = %w[monday tuesday friday saturday sunday]
  #   hours = [20, 21, 22, 23, 0]
  #   days % 25
  #   hours % 5
  # end

  def to_json(*_options)
    {
      duration:,
      enabled:,
      id:,
      next_runtimes:,
      on_scan_repeat:,
      repeat:,
      scan_engine_id:,
      scan_name:,
      scan_template_id:,
      start:
    }.to_json
  end

  def name
    scan_name
  end
end
