# frozen_string_literal: true

require_relative 'model'
require_relative 'fixture'

class App
  extend GLI::App

  desc 'Manage assets'
  arg_name 'Describe arguments to asset here'
  command :asset do |c|
    c.desc 'Describe a switch to asset'
    c.switch :s

    c.desc 'Describe a flag to asset'
    c.default_value 'default'
    c.flag :f
    c.action do |_global_options, _options, _args|
      # Your command logic specific to 'asset' here
      assets = fetch_fixtures
      assets.each do |asset|
        puts asset
      end
    end
  end
end
