# frozen_string_literal: true

require_relative 'model'

class App
  desc 'Manage softwares'
  command :software do |c|
    c.desc 'List softwares'
    c.command :list do |l|
      l.switch [:found_on_assets, 'found-on-assets'], desc: 'Operating system currently running on a asset'
      l.action do |_global_options, options, _args|
        active = options[:found_on_assets]
        if active
          App.db.software_found_on_assets.each do |software|
            puts software
          end
        else
          App.db.all(Software).each do |software|
            puts software
          end
        end
      end
    end

    # c.desc 'Delete countries'
    # c.command :delete do |d|
    #   d.desc 'Shared country unique ID'
    #   d.flag [:id]

    #   d.action do |_global_options, options, _args|
    #     id = options[:id]
    #     puts "Delete country ##{id} ..."
    #     # countrys = fetch_countrys(from: source)
    #     # countrys.each { |country| puts country }
    #   end
    # end
  end
end
