# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage reports'
  command :report do |c|
    c.flag :id, desc: 'Unique ID', type: Integer
    c.flag :name, desc: 'Name'
    c.switch [:xxx], desc: 'Report name starts with xxx'

    c.desc 'List reports'
    c.command :list do |l|
      l.action do |_global_options, options, _args|
        name = parent(options, :name)&.downcase
        xxx = parent(options, :xxx)

        App.api.fetch_reports do |report|
          next if name && !report.name.downcase.include?(name)
          next if xxx && !report.name.downcase.starts_with?('xxx')

          puts report.to_json
        end
      end
    end

    c.desc 'Update report\'s owner'
    c.command 'update:owner' do |u|
      u.flag [:id, 'owner-id'], desc: 'Owner ID', type: Integer
      u.action do |_global_options, options, _args|
        name = parent(options, :name)&.downcase
        xxx = parent(options, :xxx)
        owner_id = options[:id]
        raise 'Owner id is required' if owner_id.nil?

        App.api.fetch_reports do |report|
          next if name && !report.name.downcase.include?(name)
          next if xxx && !report.name.downcase.starts_with?('xxx')

          # puts "#{report.id},#{report.name},#{report.owner}"
          puts "#{report.name} #{report.id}"
          App.api.update_report_owner(report, owner_id)
          # puts report.to_json
        end
      end
    end

    c.desc 'Update report SQL query'
    c.command 'update:query' do |u|
      u.flag [:file], desc: 'Path to SQL query', type: String
      u.action do |_global_options, options, _args|
        name = parent(options, :name)&.downcase
        xxx = parent(options, :xxx)
        file = options[:file]
        raise 'File path is required' if file.nil?

        query = File.read(file).strip
        raise 'SQL query file is empty' if query.empty?

        App.api.fetch_reports do |report|
          next if name && !report.name.downcase.include?(name)
          next if xxx && !report.name.downcase.starts_with?('xxx')

          puts report.name
          App.api.update_report_query(report, query)
        end
      end
    end

    c.desc 'Get report by id'
    c.command :get do |g|
      g.action do |_global_options, options, _args|
        id = parent(options, :id)
        raise 'Report Id is required' if id.nil?

        report = App.api.fetch_report(id)
        puts report.to_json
      end
    end

    c.desc 'Delete report'
    c.command :delete do |d|
      d.action do |_global_options, options, _args|
        name = parent(options, :name)&.downcase
        xxx = parent(options, :xxx)
        id = parent(options, :id)

        if id
          App.api.delete_report(id)
          puts "Report with ID #{id} deleted successfully."
        else
          App.api.fetch_reports do |report|
            next if name && !report.name.downcase.include?(name)
            next if xxx && !report.name.downcase.starts_with?('xxx')

            puts report.name
            App.api.delete_report(report.id)
            puts
          end
        end
      end
    end

    c.default_command :list
  end
end
