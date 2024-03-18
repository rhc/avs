# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  desc 'Manage sites'
  command :site do |c|
    c.desc 'Filter sites by name (contains pattern)'
    c.flag [:filter]
    c.desc 'Unique ID'
    c.flag :id
    c.desc 'List sites'

    c.command :list do |l|
      l.desc 'UTR site only'
      l.switch [:utr]

      l.action do |_global_options, options, _args|
        filter = options[GLI::Command::PARENT][:filter]&.downcase
        utr = options[:utr]
        App.api.fetch_sites do |site|
          next if filter && !site.name.downcase.include?(filter)
          next if utr && !site.utr?

          puts site.to_json
        end
      end
    end

    c.desc 'List UTR sites from cmdb'
    c.command :utr_from_cmdb do |ldb|
      ldb.action do |_global_options, options, _args|
        filter = options[GLI::Command::PARENT][:filter]&.downcase
        App.db.fetch_utr_site_from_cmdb do |site|
          next if filter && !site.name.downcase.include?(filter)

          puts site.to_json
        end
      end
    end

    c.desc 'Get site by id'
    c.command :get do |g|
      g.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        puts "TODO get site id #{id}"
      end
    end

    c.desc 'Delete site'
    c.command :delete do |d|
      d.action do |_global_options, options, _args|
        id = options[GLI::Command::PARENT][:id]
        # TODO: add confirmation here
        App.api.delete_site(id:)
      end
    end
  end
end
