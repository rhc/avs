# frozen_string_literal: true

require 'roo'
require 'ruby-progressbar'
require_relative 'model'

class NucleusApi
  def fetch_projects
    fetch(Project)
  end

  def fetch_project(id)
    endpoint = [Project.url_path, id].join('/')
    Project.new get(endpoint)
  end

  # Return the first project report with the correct name
  def find_first_project_report_name(id, name)
    condition = ->(report) { report.name == name }
    find_project_report_if(id, condition) do |report|
      return report
    end
    nil
  end

  def find_all_project_report_by(
    id,
    report_name:,
    since: nil
  )
    since ||= Date.new(2024, 1, 1)
    condition = lambda do |report|
      report.name == report_name
    end
    reports = []
    find_project_report_if(id, condition) do |report|
      return reports if Date.parse(report.created_on) < since

      reports << report
    end
    reports
  end

  def find_project_report_if(id, condition)
    start = 0
    limit = 50
    found_reports = []
    loop do
      reports = fetch_project_reports(id, start:, limit:)
      break if reports.empty?

      reports.each do |report|
        # puts "#{report.created_on}"
        next unless condition.call(report)

        if block_given?
          yield(report)
        else
          found_reports << report
        end
      end
      start += limit
    end
    found_reports unless block_given?
  end

  def fetch_project_reports(id, start: 0, limit: 1)
    endpoint = [Project.url_path, id, 'reports'].join('/')
    reports = get(endpoint, { start:, limit: })
    reports.map { |report| ProjectReport.new(report.merge('project_id' => id)) }
  end

  def download_project_report(id, report_id, dir = nil)
    endpoint = [Project.url_path, id, 'reports', report_id, 'download'].join('/')
    file_content = download(endpoint)
    raise 'Download failed.' if file_content.nil?

    dir ||= download_dir

    filename ||= "#{dir}/project_#{id}_report_#{report_id}.xlsx"
    File.open(filename, 'wb') { |file| file.write(file_content) }
  end

  def extract_report_id(filename)
    match_data = filename.match(/project_\d+_report_(\d+)\.xlsx/)
    match_data[1] if match_data
  end

  def fetch_project_report_details(spreadsheet, report_id:, tabsheet_name: 'Scan Data')
    xlsx = Roo::Excelx.new(spreadsheet)
    sheet = xlsx.sheet(tabsheet_name)
    headers = xlsx.row(1)
    details = []
    row_id = 1
    total_rows = sheet.last_row - 1
    return [] if total_rows.zero?

    progress_bar = ProgressBar.create(
      title: "Fetching #{total_rows} details",
      total: total_rows,
      format: '%a %B %p%% %t'
    )

    xlsx.each_row_streaming(offset: 1) do |row|
      values = row.map(&:value)
      hash = Hash[headers.zip(values)]
      hash['report_id'] = report_id
      hash['row_id'] = row_id
      details << ProjectReportDetail.new(hash)
      row_id += 1
      progress_bar.increment
    end
    details
  end

  def fetch_project_report_findings(spreadsheet, report_id:)
    ProjectReportFinding::SEVERITIES.flat_map do |severity|
      fetch_project_report_vulns(spreadsheet, report_id:, tabsheet_name: severity)
    end
  end

  def fetch_project_report_vulns(spreadsheet, report_id:, tabsheet_name:)
    xlsx = Roo::Excelx.new(spreadsheet)
    return [] unless xlsx.sheets.include?(tabsheet_name)

    sheet = xlsx.sheet(tabsheet_name)
    headers = xlsx.row(1)
    total_rows = sheet.last_row - 1
    return [] if total_rows.zero?

    findings = []
    progress_bar = ProgressBar.create(
      title: "Fetching #{total_rows} #{tabsheet_name} findings",
      total: total_rows,
      format: '%a %B %p%% %t'
    )

    xlsx.each_row_streaming(offset: 1) do |row|
      values = row.map(&:value)
      hash = Hash[headers.zip(values)]
      hash['severity'] = tabsheet_name
      hash['report_id'] = report_id
      findings << ProjectReportFinding.new(hash)
      progress_bar.increment
    end
    findings
  end
end
