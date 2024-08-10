# frozen_string_literal: true

require 'typhoeus'
require_relative 'model'

class App
  desc 'Manage Nucleus projects'
  command :project do |c|
    c.flag [:id], desc: 'Unique ID', type: Integer
    c.flag [:name], desc: 'Project name'
    c.desc 'List Nucleus projects'

    c.command :list do |l|
      l.action do |_global_options, _options, _args|
        puts 'id,name,description,org,groups'
        App.nucleus.fetch_projects.each do |project|
          fields = [project.id, project.name, project.description, project.org, project.groups]
          quoted_fields = fields.map { |field| "\"#{field}\"" }
          puts quoted_fields.join(',')
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

    c.desc 'Save Nucleus project by Id'
    c.command :save do |l|
      l.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'The ID is required' if id.nil?

        project = App.nucleus.fetch_project(id)
        App.db.upsert(project)
        puts "Project #{project.id} - #{project.name} saved successfully."
      end
    end

    c.desc 'Upload project report details found in a directory'
    c.command 'upload-scan-data' do |dl|
      dl.flag 'download-path', desc: 'Download directory'
      dl.flag 'archive-path', desc: 'Archive directory'
      dl.action do |_global_options, options, _args|
        source_dir = options['download-path'] || App.nucleus.download_dir
        archive_dir = options['archive-path'] || App.nucleus.archive_dir
        Dir.glob("#{source_dir}/project_*_report_*.xlsx").each do |filename|
          puts filename
          report_id = App.nucleus.extract_report_id(filename)
          details = App.nucleus.fetch_project_report_details(filename, report_id:)
          vulns = App.nucleus.fetch_project_report_findings(filename, report_id:)
          App.db.save_project_report_details(details)
          App.db.save_project_report_findings(vulns)
          File.rename(filename, "#{archive_dir}/#{File.basename(filename)}")
        rescue StandardError => e
          puts "Error processing file #{filename}: #{e.message}"
          next
        end
      end
    end

    c.desc 'Download missing project report details'
    c.command 'download-missing-details' do |dl|
      dl.flag 'download-path', desc: 'Download directory'
      dl.action do |_global_options, options, _args|
        download_dir = options['download-path'] || App.nucleus.download_dir
        App.db.fetch_view('project_report_detail_missing_view') do |record|
          project_id = record[:project_id]
          report_id = record[:report_id]
          puts "Download #{download_dir}/project_#{project_id}_report_#{report_id}"
          App.nucleus.download_project_report(project_id, report_id, download_dir)
        end
      end
    end

    c.desc 'Manage project reports'
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

      r.desc 'Download a project report'
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

          puts 'Fetching details ...'

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
            puts "#{report.name} ##{report.id} #{report.created_on}"
            App.db.upsert(report) if save
            App.nucleus.download_project_report(id, report.id) if download
          end
        end
      end
    end
  end
end
