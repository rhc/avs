# frozen_string_literal: true

require 'avs/version'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
class App
  extend GLI::App
  synopsis_format :compact
  subcommand_option_handling :normal
  arguments :strict
end

Dir.glob(File.join(__dir__, 'domain', '**', 'command.rb')).each do |file|
  require_relative file
end
