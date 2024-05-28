# frozen_string_literal: true

require 'typhoeus'
require_relative 'model'

class App
  desc 'Manage projects'
  command :project do |c|
    c.flag [:id], desc: 'Unique ID', type: Integer
    c.flag [:name], desc: 'Project name'
    c.desc 'List Nucleus projects'
    c.command :list do |l|
      l.action do |_global_options, _options, _args|
        App.nucleus.fetch_projects.each do |project|
          puts project.to_json
        end
      end
    end

    c.desc 'Get Nucleus project by Id'
    c.command :get do |l|
      l.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'The ID is required' if id.nil?

        project = App.nucleus.fetch_project(id)
        puts [project.id, project.name, project.description, project.org].join('|')
      end
    end

    c.desc 'Upload project report details in a directory'
    c.command 'upload-scan-data' do |dl|
      dl.flag 'directory-name'
      dl.action do |_global_options, options, _args|
        directory_name = options['directory-name']
        raise 'Directory name is required' if directory_name.nil?

        Dir.glob("#{directory_name}/project_*_report_*.xlsx").each do |filename|
          puts filename
          report_id = App.nucleus.extract_report_id(filename)
          details = App.nucleus.fetch_project_report_details(filename, report_id:)
          App.db.save_project_report_details(details)
          File.rename(filename, "uploaded/#{filename}")
        end
      end
    end

    c.desc 'Manage projects reports'
    c.command :reports do |r|
      r.flag [:report_id, 'report-id'], desc: 'Report ID', type: Integer
      r.desc 'List current reports in a project'
      r.command :list do |l|
        l.flag :start, desc: 'Start index', default_value: 0, type: Integer
        l.flag :limit, desc: 'Number of reports (Max=100)', default_value: 1, type: Integer
        l.action do |_global_options, options, _args|
          id = options[GLI::Command::PARENT][GLI::Command::PARENT][:id]
          start = options[:start]
          limit = options[:limit]
          raise 'The ID is required' if id.nil?
          raise 'Limit must be must less or equal to 100' if limit > 100

          puts ProjectReport.headers
          App.nucleus.fetch_project_reports(id, start:, limit:).each do |report|
            puts report
          end
        end
      end

      r.desc 'Download a report in a project'
      r.command :download do |dl|
        dl.action do |_global_options, options, _args|
          id = options[GLI::Command::PARENT][GLI::Command::PARENT][:id]
          raise 'The project ID is required' if id.nil?

          report_id = options[GLI::Command::PARENT][:report_id]
          raise 'The report ID is required' if report_id.nil?

          App.nucleus.download_project_report(id, report_id)
        end
      end

      r.desc 'Upload project report details'
      r.command 'upload-details' do |dl|
        dl.flag :filename
        dl.action do |_global_options, options, _args|
          report_id = options[GLI::Command::PARENT][:report_id]
          raise 'Report Id is required' if report_id.nil?

          filename = options[:filename]
          raise 'Filename is required' if filename.nil?

          details = App.nucleus.fetch_project_report_details(filename, report_id:)
          App.db.save_project_report_details(details)
        end
      end

      r.desc 'Upload infrastructure reports'
      r.command :upload_infrastructure_reports do |l|
        l.action do |_global_options, _options, _args|
          id = 1_000_204
          report_name = 'SBSA Perimeter Vulnerability Details Report'
          report = App.nucleus.find_project_report_name(id, report_name)
          raise "#{report_name} report was not found" if report.nil?

          filename = "data/project_#{id}_report_#{report_id}"
          App.nucleus.download_project_report(id, report.id, filename)
          details = App.nucleus.fetch_project_report_details(filename, report_id:)
          App.db.save_project_report_details(details)
        end
      end

      r.desc 'Find first report by name'
      r.command :find do |l|
        l.flag ['report-name'], desc: 'Report name'
        l.action do |_global_options, options, _args|
          id = options[GLI::Command::PARENT][GLI::Command::PARENT][:id]
          report_name = options['report-name']
          raise 'The ID is required' if id.nil?
          raise 'The report name is required' if report_name.nil?

          puts ProjectReport.headers
          report = App.nucleus.find_first_project_report_name(id, report_name)
          puts report
        end
      end

      r.desc 'Find all reports by name created after a specified date'
      r.command 'find-all' do |l|
        l.flag ['report-name'], desc: 'Report name'
        l.flag ['after'], desc: 'Creation date'
        l.switch ['save'], desc: 'Save in the database', default_value: false
        l.switch ['download'], desc: 'Download the details', default_value: false
        l.action do |_global_options, options, _args|
          id = options[GLI::Command::PARENT][GLI::Command::PARENT][:id]
          raise 'The ID is required' if id.nil?

          report_name = options['report-name']
          raise 'The report name is required' if report_name.nil?

          after = options['after'] || '2024-01-01'
          since = Date.parse(after)
          save = options['save']
          download = options['download']

          puts 'Fetching reports ...'
          reports = App.nucleus.find_all_project_report_by(id, report_name:, since:)
          reports.each do |report|
            puts "#{report.name} #{report.created_on}"
            App.db.upsert(report) if save
            App.nucleus.download_project_report(id, report.id) if download
          end
        end
      end
    end
  end
end
