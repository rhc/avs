# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage site targets'
  command :site_target do |c|
    c.flag ['site-id', :site_id], desc: 'Site id', type: Integer, required: true
    c.desc 'List site targets'
    c.command :list do |l|
      l.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:site_id]
        puts SiteTarget.columns.join ','
        site_targets = App.api.fetch_all_targets(site_id)
        site_targets.each do |site_target|
          puts site_target
        end
      end
    end
    c.desc 'List domains extracted from host targets'
    c.command :domains do |d|
      d.action do |_global_options, options, _args|
        site_id = options[GLI::Command::PARENT][:site_id]
        puts 'domain'
        domains = App.api.fetch_site_target_domains(site_id)
        domains.sort.each do |domain|
          puts domain
        end
      end
    end

    # c.desc 'Delete site targets'
    # c.command :delete do |d|
    #   d.desc 'Shared site_target unique ID'
    #   d.flag [:id]

    #   d.action do |_global_options, options, _args|
    #     id = options[:id]
    #     puts "Delete site_target ##{id} ..."
    #     # site_targets = fetch_site_targets(from: source)
    #     # site_targets.each { |site_target| puts site_target }
    #   end
    # end
  end
end
