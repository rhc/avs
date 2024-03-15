# frozen_string_literal: true

Dir.glob(File.join(__dir__, 'domain', '**', 'db.rb')).each do |file|
  require_relative file
end
