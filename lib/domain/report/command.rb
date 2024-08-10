# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage reports'
  command :report do |c|
    c.flag :id, desc: 'Unique ID', type: Integer
    c.flag :name, desc: 'Name'
    c.desc 'List reports'

    c.command :list do |l|
      l.switch [:utr], desc: 'UTR report only'
      l.switch [:xxx], desc: 'Report name starts with xxx'

      l.action do |_global_options, options, _args|
        name = options[GLI::Command::PARENT][:name]&.downcase
        utr = options[:utr]
        xxx = options[:xxx]

        App.api.fetch_reports do |report|
          next if name && !report.name.downcase.include?(name)
          next if utr && !report.utr?
          next if xxx && !report.name.downcase.starts_with?('xxx')

          puts "#{report.id},#{report.name},#{report.owner}"
        end
      end
    end

    c.desc 'Get report by id'
    c.command :get do |g|
      g.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'Report Id is required' if id.nil?

        report = App.api.fetch_report(id)
        puts report.to_json
      end
    end

    c.desc 'Update owner'
    c.command 'update-owner' do |g|
      g.flag [:owner_id, 'owner-id']
      g.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        raise 'Report Id is required' if id.nil?

        report = App.api.fetch_report(id)
        raise "Report #{id} not found" if report.nil?

        owner_id = options[:owner_id]
        raise 'Report owner id is required' if owner_id.nil?

        App.api.update_report_owner(report, owner_id)
      end
    end

    c.desc 'Update all xxx report\'s owner'
    c.command 'update-owner-xxx' do |gx|
      gx.flag ['xxx-owner-id'], desc: 'xxx report owner id'
      gx.action do |_global_options, options, _args|
        owner_id = options['xxx-owner-id']
        raise 'Report owner id is required' if owner_id.nil?

        App.api.update_xxx_report_owner(owner_id)
      end
    end

    # c.desc 'Delete report by id or name'
    # c.command :delete do |d|
    #   d.action do |_global_options, options, _args|
    #     report_idte_idte_idte_id = options[GLI::Command::PARENT][:id]
    #     name = options[GLI::Command::PARENT][:name]
    #     App.api.delete_report_by report_idte_idte_idte_id:, name:
    #   end
    # end

    # c.desc 'Starts a report'
    # c.command :starts do |d|
    #   d.action do |_global_options, options, _args|
    #     report_id = options[GLI::Command::PARENT][:id]
    #     raise 'You must specify the report id.' if report_id.nil?

    #     App.api.starts_discovery_scan(report_id:)
    #   end
    # end

    # c.desc 'Delete all UTR reports'
    # c.command :delete_utr_reports do |d|
    #   d.action do |_global_options, _options, _args|
    #     App.api.delete_utr_reports
    #   end
    # end
  end
end
