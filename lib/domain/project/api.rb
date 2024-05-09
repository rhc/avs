# frozen_string_literal: true

require_relative 'model'

class NucleusApi
  def fetch_projects
    fetch(Project)
  end

  def fetch_project(id)
    endpoint = [Project.url_path, id].join('/')
    Project.new get(endpoint)
  end

  def fetch_project_reports(id)
    endpoint = [Project.url_path, id, 'reports'].join('/')
    reports = get(endpoint)
    reports.map { |report| ProjectReport.new(report) }
  end

  def download_project_report(id, report_id, filename = nil)
    endpoint = [Project.url_path, id, 'reports', report_id, 'download'].join('/')
    file_content = download(endpoint)
    raise 'Download failed.' if file_content.nil?

    filename ||= "data/project_#{id}_report_#{report_id}.xlsx"
    File.open(filename, 'wb') { |file| file.write(file_content) }
  end
end
