# frozen_string_literal: true

require_relative 'model'
# require_relative '../../service/mail'

class App
  desc 'Manage scan templates'
  command :scan_template do |c|
    c.flag [:name], desc: 'Filter scan templates by name (contains pattern)'
    c.desc 'List scan templates'

    c.command :list do |l|
      l.action do |_global_options, options, _args|
        name = parent(options, :name)&.downcase
        App.api.fetch_scan_templates do |template|
          next if name && !template.name.downcase.include?(name)

          puts template.name
          puts template.to_json
          puts
        end
      end
    end

    c.desc 'Get vulnerability scan template name by country code'
    c.command 'list:vulnerability_scan' do |f|
      f.flag [:country], desc: 'Country code'
      f.switch ['show-details'], desc: 'Display scan template details', default_value: false

      f.action do |_global_options, options, _args|
        country_code = options[:country]
        puts "Country code #{country_code}"
        template_name = App.api.get_vulnerability_scan_template_name(country_code)

        puts "Vulnerability scan template name for #{country_code}: #{template_name}"

        if options['show-details']
          scan_template = App.api.find_scan_template_by_name(template_name)
          puts '-- details --'
          puts scan_template.to_json
        end
      end
    end
  end
end
