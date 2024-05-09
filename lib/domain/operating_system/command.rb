# frozen_string_literal: true

require_relative 'model'

class App
  desc 'Manage operating systems'
  command :operating_system do |c|
    c.desc 'List countries'
    c.command :list do |l|
      l.switch [:found_on_assets, 'found-on-assets'], desc: 'Operating system currently running on a asset'
      l.action do |_global_options, options, _args|
        active = options[:found_on_assets]
        puts "Active #{active}"
        if active
          App.db.operating_system_found_on_assets.each do |os|
            puts os
          end
        else
          App.db.all(OperatingSystem).each do |os|
            puts os
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
