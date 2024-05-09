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
          puts project
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

    c.desc 'List current reports in a project'
    c.command :reports do |l|
      l.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'The ID is required' if id.nil?

        puts ProjectReport.headers
        App.nucleus.fetch_project_reports(id).each do |report|
          puts report
        end
      end
    end

    c.desc 'Download a report in a project'
    c.command :download do |dl|
      dl.flag [:report_id, 'report-id'], desc: 'Report ID', type: Integer

      dl.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'The project ID is required' if id.nil?

        report_id = options[:report_id]
        raise 'The report ID is required' if id.nil?

        App.nucleus.download_project_report(id, report_id)
      end
    end

    c.desc 'Save Nucleus projects in the database'
    c.command :save do |sdb|
      sdb.action do |_global_options, _options, _args|
        App.nucleus.fetch_projects.each do |project|
          puts [project.id, project.name].join ':'
          App.db.upsert(project)
        end
      end
    end
  end
end
